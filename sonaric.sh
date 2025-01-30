#!/bin/bash

# 컬러 정의
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export NC='\033[0m'  # No Color

# 안내 메시지
echo -e "${GREEN}Sonaric node 설치를 시작합니다.:${NC}"

# 사용자 안내 메시지
echo -e "${GREEN}설치 중 다음과 같은 안내 메시지가 나옵니다:${NC}"

echo -e "${GREEN}1. Sonaric 노드 이름을 변경하시겠습니까? (y/N):${NC}"
echo -e "${YELLOW}y를 선택하고 노드 이름을 설정하세요.${NC}"

echo -e "${GREEN}2. Sonaric ID를 저장하시겠습니까? (y/N):${NC}"
echo -e "${YELLOW}y를 선택하고 비밀번호를 설정하세요.${NC}"

echo -e "${GREEN}위 내용을 확인하셨다면, 엔터를 눌러 다음 단계로 진행해주세요...${NC}"
read -p ""

# 2. Sonaric 설치
curl -fsSL http://get.sonaric.xyz/scripts/install.sh | sh

# 3. 구동 확인
apt-get update
apt-get install sonaricd sonaric
sonaric node-info

#포트허용
used_ports=$(netstat -tuln | awk '{print $4}' | grep -o '[0-9]*$' | sort -u)

# 각 포트에 대해 ufw allow 실행
for port in $used_ports; do
    echo -e "${GREEN}포트 ${port}을(를) 허용합니다.${NC}"
    sudo ufw allow $port/tcp
done

echo -e "${GREEN}모든 사용 중인 포트가 허용되었습니다.${NC}"

# 4. 디스코드 연동
echo -e "${GREEN}2개이상의 노드를 디스코드와 연동할 수 있습니다.${NC}"
echo -e "${GREEN}디스코드로 이동하여 /addnode 명령어를 입력합니다.${NC}"
read -p "디스코드에서 나오는 당신의 verification code를 입력하세요: " CODE
sonaric node-register "$CODE"

echo -e "${YELLOW}모든 작업이 완료되었습니다. 컨트롤+A+D로 스크린을 종료해주세요.${NC}"
echo -e "${GREEN}대시보드: https://tracker.sonaric.xyz/${NC}"
echo -e "${GREEN}스크립트 작성자:https://t.me/kjkresearch${NC}"
