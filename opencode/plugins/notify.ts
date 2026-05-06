import type { Plugin } from "@opencode-ai/plugin"
import * as path from "node:path"

type OpencodeClient = {
  session: {
    get(input: { path: { id: string } }): Promise<{ data?: { parentID?: string | null } }>
  }
}

type EventProperties = Record<string, unknown>
type RecentNotifications = Map<string, number>

interface TerminalInfo {
  appName: string | null
  processName: string | null
  bundleId: string | null
}

const READY_DEDUPE_WINDOW_MS = 1500
const ERROR_DEDUPE_WINDOW_MS = 1500
const QUESTION_DEDUPE_WINDOW_MS = 1500
const PERMISSION_DEDUPE_WINDOW_MS = 1500

const SOUNDS = {
  ready: "Glass",
  error: "Basso",
  needsInput: "Submarine",
} as const

const LIGHT_MODE_ICON_PATH = path.resolve(import.meta.dir, "../assets/opencode-logo-dark.png")
const DARK_MODE_ICON_PATH = path.resolve(import.meta.dir, "../assets/opencode-logo-light.png")

const TERMINAL_INFO_BY_ENV = [
  {
    matches: () => !!process.env.GHOSTTY_RESOURCES_DIR || process.env.TERM_PROGRAM === "ghostty",
    appName: "Ghostty",
    processName: "ghostty",
  },
  {
    matches: () => !!process.env.ITERM_SESSION_ID || process.env.TERM_PROGRAM === "iTerm.app",
    appName: "iTerm",
    processName: "iTerm2",
  },
  {
    matches: () => !!process.env.KITTY_WINDOW_ID,
    appName: "kitty",
    processName: "kitty",
  },
  {
    matches: () => !!process.env.WEZTERM_PANE,
    appName: "WezTerm",
    processName: "WezTerm",
  },
  {
    matches: () => !!process.env.ALACRITTY_WINDOW_ID,
    appName: "Alacritty",
    processName: "Alacritty",
  },
  {
    matches: () => process.env.TERM_PROGRAM === "Apple_Terminal",
    appName: "Terminal",
    processName: "Terminal",
  },
  {
    matches: () => process.env.TERM_PROGRAM === "WarpTerminal",
    appName: "Warp",
    processName: "Warp",
  },
] as const

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

  const terminalInfo = await detectTerminalInfo()
  const sentViaTerminalNotifier = await sendTerminalNotifierNotification({
    title,
    message,
    sound,
    group: `opencode-${title.toLowerCase().replace(/[^a-z0-9]+/g, "-")}`,
    terminalInfo,
  })

  if (sentViaTerminalNotifier) return

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

async function runOsascript(script: string): Promise<string | null> {
  if (process.platform !== "darwin") return null

  try {
    const proc = Bun.spawn(["osascript", "-e", script], {
      stdout: "pipe",
      stderr: "ignore",
    })
    const output = await new Response(proc.stdout).text()
    const exitCode = await proc.exited
    if (exitCode !== 0) return null
    return output.trim() || null
  } catch {
    return null
  }
}

async function getBundleId(appName: string): Promise<string | null> {
  return runOsascript(`id of application "${escapeAppleScript(appName)}"`)
}

async function getFrontmostApp(): Promise<string | null> {
  return runOsascript(
    'tell application "System Events" to get name of first application process whose frontmost is true',
  )
}

async function isDarkModeEnabled(): Promise<boolean> {
  const value = await runOsascript(
    'tell application "System Events" to tell appearance preferences to get dark mode',
  )
  return value?.toLowerCase() === "true"
}

async function getNotificationIconPath(): Promise<string> {
  return (await isDarkModeEnabled()) ? DARK_MODE_ICON_PATH : LIGHT_MODE_ICON_PATH
}

async function detectTerminalInfo(): Promise<TerminalInfo> {
  const match = TERMINAL_INFO_BY_ENV.find((item) => item.matches())
  if (!match) {
    return { appName: null, processName: null, bundleId: null }
  }

  const bundleId = await getBundleId(match.appName)
  return {
    appName: match.appName,
    processName: match.processName,
    bundleId,
  }
}

async function isTerminalFocused(terminalInfo: TerminalInfo): Promise<boolean> {
  if (!terminalInfo.processName) return false

  const frontmost = await getFrontmostApp()
  if (!frontmost) return false

  return frontmost.toLowerCase() === terminalInfo.processName.toLowerCase()
}

async function sendTerminalNotifierNotification(options: {
  title: string
  message: string
  sound?: string
  group: string
  terminalInfo: TerminalInfo
}): Promise<boolean> {
  const terminalNotifierPath = Bun.which("terminal-notifier")
  if (!terminalNotifierPath) return false

  const iconPath = await getNotificationIconPath()

  const args = [
    terminalNotifierPath,
    "-title",
    options.title,
    "-message",
    options.message,
    "-group",
    options.group,
    "-appIcon",
    iconPath,
  ]

  if (options.sound) {
    args.push("-sound", options.sound)
  }

  if (options.terminalInfo.bundleId) {
    args.push("-activate", options.terminalInfo.bundleId)
  }

  try {
    const proc = Bun.spawn(args, {
      stdout: "ignore",
      stderr: "ignore",
    })
    return (await proc.exited) === 0
  } catch {
    return false
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
  terminalInfo: TerminalInfo,
): Promise<void> {
  if (!(await isParentSession(client, sessionID))) return
  if (await isTerminalFocused(terminalInfo)) return

  const dedupeKey = `ready:${sessionID}`
  if (!shouldSendDedupedNotification(recent, dedupeKey, READY_DEDUPE_WINDOW_MS)) return

  await sendMacNotification("OpenCode ready", "Task is ready for review", SOUNDS.ready)
}

async function notifyError(
  client: OpencodeClient,
  sessionID: string,
  recent: RecentNotifications,
  terminalInfo: TerminalInfo,
): Promise<void> {
  if (!(await isParentSession(client, sessionID))) return
  if (await isTerminalFocused(terminalInfo)) return

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

async function notifyPermission(
  properties: EventProperties,
  recent: RecentNotifications,
  terminalInfo: TerminalInfo,
): Promise<void> {
  if (await isTerminalFocused(terminalInfo)) return

  const dedupeKey = buildPermissionKey(properties)
  if (!shouldSendDedupedNotification(recent, dedupeKey, PERMISSION_DEDUPE_WINDOW_MS)) return

  await sendMacNotification("OpenCode waiting", "Permission needed", SOUNDS.needsInput)
}

export const NotifyPlugin: Plugin = async ({ client }) => {
  if (process.platform !== "darwin") return {}

  const terminalInfo = await detectTerminalInfo()
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
            await notifyReady(client as OpencodeClient, sessionID, recentReadyNotifications, terminalInfo)
          }
          break
        }
        case "session.idle": {
          const sessionID = toNonEmptyString(properties.sessionID)
          if (sessionID) {
            await notifyReady(client as OpencodeClient, sessionID, recentReadyNotifications, terminalInfo)
          }
          break
        }
        case "session.error": {
          const sessionID = toNonEmptyString(properties.sessionID)
          if (sessionID) {
            await notifyError(client as OpencodeClient, sessionID, recentErrorNotifications, terminalInfo)
          }
          break
        }
        case "permission.asked":
        case "permission.updated": {
          await notifyPermission(properties, recentPermissionNotifications, terminalInfo)
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
