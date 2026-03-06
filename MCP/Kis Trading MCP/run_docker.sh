#!/bin/bash

# 한국투자증권 MCP 서버 Docker 실행 스크립트
# 아래 환경변수를 본인의 API 정보로 수정한 뒤 실행하세요.

docker run -d \
  --name kis-trade-mcp \
  -p 3000:3000 \
  -e KIS_APP_KEY="your_app_key" \
  -e KIS_APP_SECRET="your_app_secret" \
  -e KIS_HTS_ID="your_hts_id" \
  -e KIS_PROD_TYPE="01" \
  -e KIS_ACCT_STOCK="your_account_number" \
  kis-trade-mcp
