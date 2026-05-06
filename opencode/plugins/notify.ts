import type { Plugin } from "@opencode-ai/plugin"

type OpencodeClient = {
  session: {
    get(input: { path: { id: string } }): Promise<{ data?: { parentID?: string | null } }>
  }
}

type EventProperties = Record<string, unknown>
type RecentNotifications = Map<string, number>

const READY_DEDUPE_WINDOW_MS = 1500
const ERROR_DEDUPE_WINDOW_MS = 1500
const QUESTION_DEDUPE_WINDOW_MS = 1500
const PERMISSION_DEDUPE_WINDOW_MS = 1500

const SOUNDS = {
  ready: "Glass",
  error: "Basso",
  needsInput: "Submarine",
} as const

function toNonEmptyString(value: unknown): string | null {
  if (typeof value !== "string") return null
  const normalized = value.trim()
  return normalized ? normalized : null
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value)
}

function escapeAppleScript(value: string): string {
  return value
    .replace(/\\/g, "\\\\")
    .replace(/"/g, '\\"')
    .replace(/\n/g, " ")
    .replace(/\r/g, " ")
}

async function sendMacNotification(title: string, message: string, sound?: string): Promise<void> {
  if (process.platform !== "darwin") return

  const clauses = [
    `display notification "${escapeAppleScript(message)}" with title "${escapeAppleScript(title)}"`,
  ]

  if (sound) {
    clauses.push(`sound name "${escapeAppleScript(sound)}"`)
  }

  try {
    const proc = Bun.spawn(["osascript", "-e", clauses.join(" ")], {
      stdout: "ignore",
      stderr: "ignore",
    })
    await proc.exited
  } catch {
    // Best effort only - notifications should never break OpenCode.
  }
}

function shouldSendDedupedNotification(
  recentNotifications: RecentNotifications,
  dedupeKey: string,
  windowMs: number,
  nowMs = Date.now(),
): boolean {
  for (const [key, timestamp] of recentNotifications) {
    if (nowMs - timestamp >= windowMs) {
      recentNotifications.delete(key)
    }
  }

  const lastSentAt = recentNotifications.get(dedupeKey)
  if (lastSentAt !== undefined && nowMs - lastSentAt < windowMs) {
    return false
  }

  recentNotifications.set(dedupeKey, nowMs)
  return true
}

function getSessionStatusType(properties: EventProperties): string | null {
  if (!isRecord(properties.status)) return null
  return toNonEmptyString(properties.status.type)?.toLowerCase() ?? null
}

function buildSessionKey(prefix: string, sessionID: unknown): string | null {
  const normalizedSessionID = toNonEmptyString(sessionID)
  return normalizedSessionID ? `${prefix}:${normalizedSessionID}` : null
}

function buildQuestionToolKey(sessionID: unknown, callID: unknown): string | null {
  const normalizedSessionID = toNonEmptyString(sessionID)
  const normalizedCallID = toNonEmptyString(callID)
  if (!normalizedSessionID || !normalizedCallID) return null
  return `question:${normalizedSessionID}:${normalizedCallID}`
}

function buildQuestionEventKey(properties: EventProperties): string | null {
  const sessionID = toNonEmptyString(properties.sessionID)
  if (!sessionID) return null

  const tool = isRecord(properties.tool) ? properties.tool : undefined
  const callID = toNonEmptyString(tool?.callID)
  if (callID) return `question:${sessionID}:${callID}`

  const requestID = toNonEmptyString(properties.id)
  if (requestID) return `question:${sessionID}:request:${requestID}`

  return `question:${sessionID}`
}

function buildPermissionKey(properties: EventProperties): string {
  const requestID = toNonEmptyString(properties.id)
  return requestID ? `permission:${requestID}` : "permission"
}

async function isParentSession(client: OpencodeClient, sessionID: string): Promise<boolean> {
  try {
    const session = await client.session.get({ path: { id: sessionID } })
    return !session.data?.parentID
  } catch {
    return true
  }
}

async function notifyReady(
  client: OpencodeClient,
  sessionID: string,
  recent: RecentNotifications,
): Promise<void> {
  if (!(await isParentSession(client, sessionID))) return

  const dedupeKey = `ready:${sessionID}`
  if (!shouldSendDedupedNotification(recent, dedupeKey, READY_DEDUPE_WINDOW_MS)) return

  await sendMacNotification("OpenCode ready", "Task is ready for review", SOUNDS.ready)
}

async function notifyError(
  client: OpencodeClient,
  sessionID: string,
  recent: RecentNotifications,
): Promise<void> {
  if (!(await isParentSession(client, sessionID))) return

  const dedupeKey = `error:${sessionID}`
  if (!shouldSendDedupedNotification(recent, dedupeKey, ERROR_DEDUPE_WINDOW_MS)) return

  await sendMacNotification("OpenCode error", "Session failed", SOUNDS.error)
}

async function notifyQuestion(dedupeKey: string | null, recent: RecentNotifications): Promise<void> {
  if (dedupeKey && !shouldSendDedupedNotification(recent, dedupeKey, QUESTION_DEDUPE_WINDOW_MS)) {
    return
  }

  await sendMacNotification("OpenCode question", "Input needed", SOUNDS.needsInput)
}

async function notifyPermission(properties: EventProperties, recent: RecentNotifications): Promise<void> {
  const dedupeKey = buildPermissionKey(properties)
  if (!shouldSendDedupedNotification(recent, dedupeKey, PERMISSION_DEDUPE_WINDOW_MS)) return

  await sendMacNotification("OpenCode waiting", "Permission needed", SOUNDS.needsInput)
}

export const NotifyPlugin: Plugin = async ({ client }) => {
  if (process.platform !== "darwin") return {}

  const recentReadyNotifications: RecentNotifications = new Map()
  const recentErrorNotifications: RecentNotifications = new Map()
  const recentQuestionNotifications: RecentNotifications = new Map()
  const recentPermissionNotifications: RecentNotifications = new Map()

  return {
    "tool.execute.before": async (input) => {
      if (String(input?.tool ?? "").toLowerCase() !== "question") return

      await notifyQuestion(
        buildQuestionToolKey((input as Record<string, unknown>).sessionID, (input as Record<string, unknown>).callID),
        recentQuestionNotifications,
      )
    },
    event: async ({ event }) => {
      const runtimeEvent = isRecord(event) ? event : {}
      const eventType = toNonEmptyString(runtimeEvent.type)
      const properties = isRecord(runtimeEvent.properties) ? runtimeEvent.properties : {}
      if (!eventType) return

      switch (eventType) {
        case "session.status": {
          const sessionID = toNonEmptyString(properties.sessionID)
          if (sessionID && getSessionStatusType(properties) === "idle") {
            await notifyReady(client as OpencodeClient, sessionID, recentReadyNotifications)
          }
          break
        }
        case "session.idle": {
          const sessionID = toNonEmptyString(properties.sessionID)
          if (sessionID) {
            await notifyReady(client as OpencodeClient, sessionID, recentReadyNotifications)
          }
          break
        }
        case "session.error": {
          const sessionID = toNonEmptyString(properties.sessionID)
          if (sessionID) {
            await notifyError(client as OpencodeClient, sessionID, recentErrorNotifications)
          }
          break
        }
        case "permission.asked":
        case "permission.updated":
        case "permission.replied": {
          await notifyPermission(properties, recentPermissionNotifications)
          break
        }
        case "question.asked": {
          await notifyQuestion(buildQuestionEventKey(properties), recentQuestionNotifications)
          break
        }
      }
    },
  }
}

export default NotifyPlugin
