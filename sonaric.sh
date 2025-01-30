#!/bin/bash

# 컬러 정의
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export NC='\033[0m'  # No Color

# 함수: 명령어 실행 및 결과 확인, 오류 발생 시 사용자에게 계속 진행할지 묻기
execute_with_prompt() {
    local message="$1"
    local command="$2"
    echo -e "${YELLOW}${message}${NC}"
    echo "Executing: $command"
    
    # 명령어 실행 및 오류 내용 캡처
    output=$(eval "$command" 2>&1)
    exit_code=$?

    # 출력 결과를 화면에 표시
    echo "$output"

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Error: Command failed: $command${NC}" >&2
        echo -e "${RED}Detailed Error Message:${NC}"
        echo "$output" | sed 's/^/  /'  # 상세 오류 메시지를 들여쓰기하여 출력
        echo
        
        # 사용자에게 계속 진행할지 묻기
        read -p "오류가 발생했습니다. 계속 진행하시겠습니까? (Y/N): " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${RED}스크립트를 종료합니다.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Success: Command completed successfully.${NC}"
    fi
}

# 안내 메시지
echo -e "${GREEN}Sonaric node 설치를 시작합니다.:${NC}"

# 1. UFW 설치 및 포트 개방
echo -e "${YELLOW}UFW를 활성화합니다.:${NC}"
sudo ufw allow 44003/tcp
sudo ufw allow 44004/tcp
sudo ufw allow 44005/tcp
sudo ufw allow 44006/tcp

# 사용자 안내 메시지
echo -e "${GREEN}설치 중 다음과 같은 안내 메시지가 나옵니다:${NC}"

echo -e "${GREEN}1. Sonaric 노드 이름을 변경하시겠습니까? (y/N):${NC}"
echo -e "${YELLOW}y를 선택하고 노드 이름을 설정하세요.${NC}"

echo -e "${GREEN}2. Sonaric ID를 저장하시겠습니까? (y/N):${NC}"
echo -e "${YELLOW}y를 선택하고 비밀번호를 설정하세요.${NC}"

# 2. Sonaric 설치 스크립트 실행
execute_with_prompt "Sonaric 설치 스크립트를 실행합니다.시간이 오래걸리니 충분히 기다려주세요" "curl -fsSL http://get.sonaric.xyz/scripts/install.sh | sh"

# 3. 구동 확인
apt-get update
apt-get install sonaricd sonaric
execute_with_prompt "Sonaric 노드 상태를 확인합니다..." "sonaric node-info"

# 4. 디스코드 연동
echo -e "${GREEN}2개이상의 노드를 디스코드와 연동할 수 있습니다.${NC}"
echo -e "${GREEN}디스코드로 이동하여 /addnode 명령어를 입력합니다.${NC}"
read -p "디스코드에서 나오는 당신의 verification code를 입력하세요: " CODE
sonaric node-register "$CODE"

# 5. 앱 연동
echo -e "${GREEN}Sonaric은 앱으로도 설치가 가능합니다. 간단하게 설명드리겠습니다.${NC}"
echo -e "${GREEN}1.Sonaric 앱을 다운로드 받아주세요.${NC}"
echo -e "${GREEN}2.https://docs.sonaric.xyz/installation/ 이곳에서 필요한 운영체재에 해당되는 어플을 받을 수 있습니다.${NC}"
echo -e "${GREEN}3.통합 탭에서 디스코드를 연동해주세요.${NC}"
echo -e "${GREEN}4.코드를 입력하라는 메시지가 표시됩니다. 위와 동일한 방식으로 디스코드에서 code를 받아주시면 됩니다.${NC}"

echo -e "${YELLOW}모든 작업이 완료되었습니다. 컨트롤+A+D로 스크린을 종료해주세요.${NC}"
echo -e "${GREEN}대시보드: https://tracker.sonaric.xyz/${NC}"
echo -e "${GREEN}스크립트 작성자:https://t.me/kjkresearch${NC}"
