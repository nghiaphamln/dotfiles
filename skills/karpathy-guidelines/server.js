import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";

const id = "karpathy-guidelines";
const path = fileURLToPath(new URL("./skill/SKILL.md", import.meta.url));

export default {
  id,
  async setup(ctx) {
    const markdown = await readFile(path, "utf8");
    const match = /^---\r?\n([\s\S]*?)\r?\n---\r?\n([\s\S]+)$/.exec(markdown);
    if (!match) throw new Error(`Missing skill frontmatter in ${path}`);

    const [, frontmatter, body] = match;
    const { name, description } = Bun.YAML.parse(frontmatter);
    if (typeof name !== "string" || typeof description !== "string") {
      throw new Error(`Missing skill name or description in ${path}`);
    }

    await ctx.skill.transform((editor) => {
      editor.add({ id, name, description, path, content: body.trim() });
    });
  },
};
