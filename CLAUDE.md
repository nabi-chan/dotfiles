# chezmoi dotfiles

chezmoi로 관리하는 dotfiles 저장소.

## Commands

```bash
chezmoi diff          # 변경사항 미리보기
chezmoi apply         # 홈 디렉토리에 적용
chezmoi add <file>    # 새 파일 관리 시작
chezmoi edit <file>   # 관리 중인 파일 편집
```

## Structure

- `dot_` 접두사 → 홈 디렉토리의 `.` 파일/폴더로 매핑 (예: `dot_claude/` → `~/.claude/`)
- `.tmpl` 접미사 → chezmoi 템플릿 (Go template 문법)
- `.chezmoidata.yaml` → 템플릿 변수 정의
- `.chezmoiscripts/` → 설치/업데이트 시 실행되는 스크립트

## Gotchas

- 파일 직접 수정 금지: `~/.claude/CLAUDE.md`가 아닌 `dot_claude/CLAUDE.md`를 수정해야 함
- `.tmpl` 파일은 Go template 문법을 사용하므로 `{{ }}` 구문 주의
