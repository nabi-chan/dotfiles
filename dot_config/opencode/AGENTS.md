## General

- 불명확한 사항은 가정하지 말고 질문하기
- 주석/커밋메시지/답변은 한국어로 작성하기

## Environment

- Docker 런타임: OrbStack
- 런타임 관리: mise (`~/.config/mise/mise.toml`)
  - 언어: java 21, node 22, python 3.14, bun 1.3
  - 패키지 매니저: pnpm 10
  - CLI: awscli 2, pulumi 3, wrangler 4, 1password 2
- 버전 확인: `mise list`, 설치: `mise install`
- `ls`/`cat`은 alias에 ANSI 컬러가 포함되어 있으므로 Bash에서 사용 시 `/bin/ls`, `/bin/cat`을 직접 호출

## Coding Preferences

- 과도한 추상화를 피하고 명확하고 단순한 코드 선호
- 프로젝트에 이미 존재하는 패턴과 컨벤션을 우선 따르기
- 새 의존성 추가 전에 기존 의존성으로 해결 가능한지 먼저 확인

## Subagents

- 독립적으로 병렬 수행 가능한 서브태스크가 2개 이상일 때 서브에이전트 사용
- 단순 순차 작업이나 서로 의존적인 작업은 서브에이전트 없이 직접 수행

## Temp Files

- 임시 파일은 `~/.opencode-temp/<목적>` 하위에 폴더로 관리
- 프로젝트별 임시 파일은 `./temp.local/<목적>` 하위에 폴더로 관리
- 작업 완료 후 해당 폴더 정리
