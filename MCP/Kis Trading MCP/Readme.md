# 중요 : MCP에 대한 내용을 완전히 숙지하신 뒤 사용해 주십시오.
#       이 프로그램을 실행하여 발생한 모든 책임은 사용자 본인에게 있습니다.

# 한국투자증권 OPEN API MCP 서버

한국투자증권의 다양한 금융 API를 Docker를 통해 Claude Desktop 등 MCP 클라이언트에서 쉽게 사용할 수 있도록 하는 MCP 서버입니다.

## 주요 기능

### 지원하는 API 카테고리

| 카테고리 | 개수 | 주요 기능 |
|---------|------|----------|
| 국내주식 | 74개 | 현재가, 호가, 차트, 잔고, 주문, 순위분석, 시세분석, 종목정보, 실시간시세 등 |
| 해외주식 | 34개 | 미국/아시아 주식 시세, 잔고, 주문, 체결내역, 거래량순위, 권리종합 등 |
| 국내선물옵션 | 20개 | 선물옵션 시세, 호가, 차트, 잔고, 주문, 야간거래, 실시간체결 등 |
| 해외선물옵션 | 19개 | 해외선물 시세, 주문내역, 증거금, 체결추이, 옵션호가 등 |
| 국내채권 | 14개 | 채권 시세, 호가, 발행정보, 잔고조회, 주문체결내역 등 |
| ETF/ETN | 2개 | NAV 비교추이, 현재가 등 |
| ELW | 1개 | ELW 거래량순위 |

**전체 API 총합계: 166개**

### 핵심 특징
- **동적 코드 실행**: GitHub에서 실시간으로 API 코드를 다운로드하여 실행
- **설정 기반**: JSON 파일로 API 설정 및 파라미터 관리
- **안전한 실행**: 격리된 임시 환경에서 코드 실행
- **환경 지원**: 실전/모의 환경 구분 지원
- **다중 전송 모드**: stdio, SSE, streamable-http 지원
- **크로스 플랫폼**: Windows, macOS, Linux 모두 지원

## 요구사항

- Docker 20.10+
- 한국투자증권 OPEN API 계정

## Docker 설치

### macOS
```bash
# Homebrew 사용 (권장)
brew install --cask docker

# 또는 공식 인스톨러 다운로드
# https://www.docker.com/products/docker-desktop/
```

### Linux (Ubuntu/Debian)
```bash
# 공식 스크립트 사용 (권장)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 사용자를 docker 그룹에 추가
sudo usermod -aG docker $USER
```

### Windows

1. **시스템 요구사항 확인**
   - Windows 10/11 Pro, Enterprise, Education
   - WSL2 또는 Hyper-V 지원

2. **Docker Desktop 설치**
   - [공식 사이트](https://www.docker.com/products/docker-desktop/)에서 다운로드
   - 설치 중 "Use WSL 2" 옵션 선택 권장

3. **설치 후 확인**
   ```cmd
   docker --version
   docker run hello-world
   ```

**Windows 상세 설치 가이드**: [Docker 공식 문서](https://docs.docker.com/desktop/install/windows-install/) 참조

## 설치 및 실행

### 1단계: 프로젝트 클론

```bash
git clone https://github.com/JaegeonJo/open-trading-api.git
cd "open-trading-api/MCP/Kis Trading MCP"
```

### 2단계: 한국투자증권 API 정보 준비

[한국투자증권 개발자 센터](https://apiportal.koreainvestment.com/)에서 API 키를 발급받아야 합니다.

**발급 절차:**
1. [한국투자증권 개발자 센터](https://apiportal.koreainvestment.com/)에 접속하여 회원가입/로그인
2. **[API 신청]** 메뉴에서 실전도메인 또는 모의도메인 API 신청
3. 신청 완료 후 **App Key**와 **App Secret**이 발급됨
4. **[계좌 관리]** 메뉴에서 API 연동할 계좌번호 확인

**필수 정보:**
| 항목 | 설명 | 예시 |
|------|------|------|
| App Key | API 인증 키 | `PSxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` |
| App Secret | API 인증 시크릿 | `aCxxxxxxxxxxxxxxxxxxxxxxxx...` |
| HTS ID | 한국투자증권 HTS 아이디 | `홍길동` |
| 계좌번호 | 주식 거래용 계좌번호 (8자리) | `12345678` |
| 상품유형 | 계좌 상품유형 코드 | `01` |

**선택 정보 (모의투자):**
| 항목 | 설명 |
|------|------|
| Paper App Key | 모의투자용 API 인증 키 |
| Paper App Secret | 모의투자용 API 인증 시크릿 |

> 모의투자 API는 별도로 신청해야 하며, 실전 투자 전 모의투자로 충분히 테스트하는 것을 권장합니다.

---

### 3단계: Docker 이미지 빌드

```bash
docker build -t kis-trade-mcp .
```

### 4단계: run_docker.sh로 컨테이너 실행

`run_docker.sh` 스크립트를 사용하면 간편하게 컨테이너를 실행할 수 있습니다.

```bash
# 1. 스크립트 내 환경변수를 본인 정보로 수정
vi run_docker.sh
```

`run_docker.sh` 내용:
```bash
docker run -d \
  --name kis-trade-mcp \
  -p 3000:3000 \
  -e KIS_APP_KEY="your_app_key" \
  -e KIS_APP_SECRET="your_app_secret" \
  -e KIS_HTS_ID="your_hts_id" \
  -e KIS_PROD_TYPE="01" \
  -e KIS_ACCT_STOCK="your_account_number" \
  kis-trade-mcp
```

**macOS / Linux:**
```bash
# 실행 권한 부여 및 실행
chmod +x run_docker.sh
./run_docker.sh
```

**Windows (PowerShell):**
```powershell
# Git Bash가 설치되어 있는 경우
bash run_docker.sh

# 또는 PowerShell에서 직접 실행
docker run -d `
  --name kis-trade-mcp `
  -p 3000:3000 `
  -e KIS_APP_KEY="your_app_key" `
  -e KIS_APP_SECRET="your_app_secret" `
  -e KIS_HTS_ID="your_hts_id" `
  -e KIS_PROD_TYPE="01" `
  -e KIS_ACCT_STOCK="your_account_number" `
  kis-trade-mcp
```

**Windows (명령 프롬프트 / cmd):**
```cmd
docker run -d --name kis-trade-mcp -p 3000:3000 -e KIS_APP_KEY="your_app_key" -e KIS_APP_SECRET="your_app_secret" -e KIS_HTS_ID="your_hts_id" -e KIS_PROD_TYPE="01" -e KIS_ACCT_STOCK="your_account_number" kis-trade-mcp
```

> **주의**: `run_docker.sh`에 실제 API 키를 입력한 뒤에는 절대 Git에 커밋하지 마세요.

### 5단계: 컨테이너 상태 확인

```bash
# 상태 확인
docker ps

# 로그 확인
docker logs kis-trade-mcp

# 실시간 로그
docker logs -f kis-trade-mcp

# HTTP 서버 접근 확인
curl http://localhost:3000/sse
```

### 6단계: MCP 클라이언트 연동

Docker 컨테이너가 실행 중일 때, MCP 클라이언트에 서버를 등록합니다.

#### Claude Desktop

설정 파일에 아래 내용을 추가합니다.

**설정 파일 위치:**
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "kis-trade-mcp": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:3000/sse"]
    }
  }
}
```

#### Claude Code (CLI)

터미널에서 아래 명령어를 실행하면 MCP 서버가 등록됩니다.

```bash
claude mcp add kis-trade-mcp http://localhost:3000/sse
```

등록 확인:
```bash
claude mcp list
```

### 컨테이너 관리

```bash
docker start kis-trade-mcp      # 시작
docker stop kis-trade-mcp       # 중지
docker restart kis-trade-mcp    # 재시작

# 제거
docker stop kis-trade-mcp && docker rm kis-trade-mcp
```

---

## 사용법 및 질문 예시

### 기본 사용 패턴

1. **종목 검색**: 먼저 종목 코드를 찾습니다
2. **API 확인**: 사용할 API의 파라미터를 확인합니다
3. **API 호출**: 필요한 파라미터와 함께 API를 호출합니다

### 질문 예시

**주식 시세 조회:**
- "삼성전자(005930) 현재가 시세 조회해줘"
- "애플(AAPL) 해외주식 현재 체결가 알려줘"

**잔고 및 계좌:**
- "국내주식 잔고 조회해줘"
- "해외주식 잔고 확인해줘"

**채권 및 기타:**
- "국고채 3년물 호가 정보 조회하는 방법"
- "KODEX 200 ETF(069500) NAV 비교추이 확인해줘"

**모의투자:**
- "모의투자로 삼성전자 현재가 조회해줘"

## 문제 해결

**컨테이너가 시작되지 않는 경우:**
```bash
docker logs kis-trade-mcp
docker exec kis-trade-mcp env | grep KIS
```

**네트워크 연결 문제:**
```bash
docker port kis-trade-mcp
curl http://localhost:3000/sse
```

**의존성 문제:**
```bash
docker build --no-cache -t kis-trade-mcp .
```

## 관련 링크

- [한국투자증권 개발자 센터](https://apiportal.koreainvestment.com/)
- [한국투자증권 OPEN API GitHub (원본)](https://github.com/koreainvestment/open-trading-api)
- [MCP (Model Context Protocol) 공식 문서](https://modelcontextprotocol.io/)
- [Docker 공식 문서](https://docs.docker.com/)

---

**주의**: 이 프로젝트는 한국투자증권 OPEN API를 사용합니다. 사용 전 반드시 [한국투자증권 개발자 센터](https://apiportal.koreainvestment.com/)에서 API 이용약관을 확인하시기 바랍니다.

## 투자 책임 고지

**본 MCP 서버는 한국투자증권 OPEN API를 활용한 도구일 뿐이며, 투자 조언이나 권유를 제공하지 않습니다.**

- 모든 투자 결정과 그에 따른 손익은 전적으로 투자자 본인의 책임입니다
- 주식, 선물, 옵션 등 모든 금융상품 투자에는 원금 손실 위험이 있습니다
- API를 통해 제공되는 정보의 정확성은 한국투자증권에 의존하며, 투자 전 반드시 정보를 검증하시기 바랍니다
- 실전 투자 전 반드시 모의투자를 통해 충분히 연습하시기 바랍니다

**투자는 본인의 판단과 책임 하에 이루어져야 하며, 본 도구 사용으로 인한 어떠한 손실에 대해서도 개발자는 책임지지 않습니다.**
