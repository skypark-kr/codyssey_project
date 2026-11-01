# Codyssey Week 1 — 개발 워크스테이션 구축

> 코디세이 AI 올인원 제1기 입학연수 · 미션 1-1  
> 과제명: **내 컴퓨터에 개발자용 '작업실' 꾸미기**  
> 작성 기준: **2026년 11월 1일 실제 터미널 실행 기록**

## 1. 프로젝트 개요

이 프로젝트는 터미널, Git/GitHub, Docker를 사용해 개발 환경을 구축하고, 명령어와 실행 결과를 기록하는 코디세이 입학연수 미션이다.

현재까지 **GitHub 저장소 연결, Bash 터미널 기본 조작, 파일·디렉터리 생성/복사/이동/삭제, Git 커밋 및 푸시**를 실습했다. **Docker 설치 및 컨테이너 실습, 리눅스 권한 변경 실습은 아직 수행하지 않았다.**

- GitHub 저장소: <https://github.com/skypark-kr/codyssey_project>
- 로컬 프로젝트 경로: `C:\codyssey-week1\codyssey_project`
- 기본 브랜치: `main`

## 2. 실행 환경
OS: Microsoft Windows [Version 10.0.26300.9711]
Shell: CMD
Terminal: VS Code Integrated Terminal
Git version: git version 2.56.0.windows.4
Docker version: Docker version 29.9.2, build a82e528
Editor: Visual Studion Code

## 3. 수행 현황 체크리스트

- [x] GitHub 저장소 생성 및 `main` 브랜치 연결 확인
- [x] 터미널에서 현재 위치 확인 (`pwd`)
- [x] 숨김 파일을 포함한 목록 확인 (`ls -la`)
- [x] 폴더 이동 (`cd`)
- [x] 디렉터리 생성 (`mkdir`, `mkdir -p`)
- [x] 빈 파일 생성 (`touch`)
- [x] 파일 내용 작성 및 확인 (`echo`, `cat`)
- [x] 파일 복사 (`cp`)
- [x] 파일 이름 변경 및 이동 (`mv`)
- [x] 파일 및 빈 디렉터리 삭제 (`rm`, `rmdir`)
- [x] Git 변경사항 확인 (`git status`)
- [x] Git 스테이징·커밋·푸시 (`git add`, `git commit`, `git push`)
- [ ] Git 사용자 정보, Git 버전, 기본 브랜치의 전역 설정 기록 (`git config --list`, `git --version`)
- [ ] **리눅스 환경**에서 파일 1개·디렉터리 1개 권한 변경 전후 확인 (`chmod`, `ls -ld`)
- [ ] Docker 설치 및 데몬 확인 (`docker --version`, `docker info`)
- [ ] Docker 이미지·컨테이너 명령어 검증 (`docker images`, `docker ps -a`, `docker logs`, `docker stats` 등)
- [ ] `hello-world`, Ubuntu 컨테이너 실행 및 내부 명령 수행
- [ ] 직접 작성한 `Dockerfile`로 커스텀 이미지 빌드 및 웹 서버 실행
- [ ] 포트 매핑을 이용한 웹 서버 접속 검증 (브라우저 주소창 포함 캡처)
- [ ] 바인드 마운트의 파일 변경 반영 검증
- [ ] Docker 볼륨의 데이터 영속성 검증
- [ ] VS Code ↔ GitHub 로그인·연동 증거 캡처 첨부
- [ ] 터미널 조작/권한/Docker 실행 로그 및 증거 정리 최종 완료

4. 실습 및 검증 결과
실습을 진행하면서 명령어와 실제 실행 결과를 기록한다. 

5. 트러블슈팅
실제로 발생한 오류와 해결 과정을 기록한다. 