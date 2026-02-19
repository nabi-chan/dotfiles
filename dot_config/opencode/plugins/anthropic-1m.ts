import type { Plugin } from "@opencode-ai/plugin";

// Anthropic API에서 1M context window + adaptive thinking을 활성화하는 beta 헤더 주입
// https://docs.anthropic.com/en/docs/build-with-claude/context-windows#1m-token-context-window
// https://docs.anthropic.com/en/docs/build-with-claude/adaptive-thinking
// https://github.com/anomalyco/opencode/issues/12338
// https://github.com/anomalyco/opencode/pull/12342

const BETA_HEADERS = ["context-1m-2025-08-07", "adaptive-thinking-2026-01-28"];

const SUPPORTED_MODELS = ["opus-4-6", "sonnet-4-5", "sonnet-4-6"];

export const plugin: Plugin = async () => ({
  "chat.params": async (input, output) => {
    if (input.model.providerID !== "anthropic") return;
    if (!input.model.api.id.includes("claude")) return;
    if (!SUPPORTED_MODELS.some((m) => input.model.api.id.includes(m))) return;
    const existing: string[] = output.options.anthropicBeta ?? [];
    const missing = BETA_HEADERS.filter((h) => !existing.includes(h));
    if (missing.length === 0) return;
    output.options.anthropicBeta = [...existing, ...missing];
  },
});
