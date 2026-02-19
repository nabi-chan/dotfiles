---
description: chezmoi dotfiles 관리 (diff, apply, add, edit, status)
---

chezmoi dotfiles 관리 명령을 실행합니다.

서브커맨드: `$1`
추가 인자: `$2`

## 서브커맨드별 동작

### diff
`chezmoi diff`를 실행하여 현재 소스와 홈 디렉토리 간의 차이를 확인합니다.
변경된 파일 목록과 diff 내용을 분석하여 사용자에게 요약해주세요.

### apply
1. 먼저 `chezmoi diff`로 적용될 변경사항을 미리 확인합니다.
2. 변경사항을 사용자에게 요약하고, 적용 여부를 확인합니다.
3. 사용자가 승인하면 `chezmoi apply`를 실행합니다.
4. 적용 결과를 보고합니다.

### add
`$2`로 전달된 파일 경로를 `chezmoi add $2`로 관리 대상에 추가합니다.
추가 후 chezmoi 소스 디렉토리에 생성된 파일 위치를 알려주세요.
`$2`가 비어있으면 어떤 파일을 추가할지 사용자에게 물어보세요.

### edit
`$2`로 전달된 파일의 chezmoi 소스 경로를 `chezmoi source-path $2`로 찾아서 해당 파일을 편집합니다.
`.tmpl` 파일인 경우 Go template 문법에 주의하세요.
`$2`가 비어있으면 어떤 파일을 편집할지 사용자에게 물어보세요.

### status
`chezmoi status`를 실행하여 관리 대상 파일들의 상태를 확인합니다.
상태 코드(A: 추가, M: 수정, D: 삭제, R: 스크립트 실행)를 설명해주세요.

### (인자 없음)
위 서브커맨드 목록을 안내하세요:
- `/chezmoi diff` — 변경사항 미리보기
- `/chezmoi apply` — 홈 디렉토리에 적용
- `/chezmoi add <파일>` — 새 파일 관리 시작
- `/chezmoi edit <파일>` — 관리 중인 파일 편집
- `/chezmoi status` — 파일 상태 확인

## 주의사항

- chezmoi 소스 디렉토리는 `~/.local/share/chezmoi`입니다.
- `dot_` 접두사는 홈 디렉토리의 `.` 파일/폴더로 매핑됩니다.
- `.tmpl` 파일은 Go template으로 렌더링됩니다.
- `private_` 접두사 파일은 권한이 600으로 설정됩니다.
- `symlink_` 접두사 파일은 심링크로 생성됩니다.
