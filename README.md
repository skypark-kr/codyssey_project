# Codyssey 1주차 미션 1-1 | 내 컴퓨터에 개발자용 작업실 꾸미기

> GitHub 저장소: <https://github.com/skypark-kr/codyssey_project>  

## 0. 프로젝트 개요 및 학습 목표

이 미션의 목적은 단순히 명령어를 입력하는 것이 아니라 개발 도구가 어떻게 연결되는지 확인하는 것이다. Windows에서 MSYS2 UCRT64 Bash로 파일을 관리하고, Git으로 변경 이력을 기록하며, Docker로 독립된 실행 환경을 구성하였다. Ubuntu 컨테이너에서 파일 권한을 바꾸고, NGINX 기반 이미지를 빌드하여 HTTP 접속을 검증했다. 바인드 마운트로 파일 변경을 즉시 반영하고, 이름 있는 Docker 볼륨을 활용해 데이터 영속성과 백업·복원을 확인했다.

- **Windows 호스트:** 프로젝트 소스코드 및 VS Code/Git Bash 실행 환경
- **Git / GitHub:** 로컬 프로젝트 파일의 이력 관리 및 원격 저장소 공유
- **Docker 이미지:** Dockerfile로 제작한 실행 환경의 원본
- **Docker 컨테이너:** 이미지에서 생성된 독립 실행 인스턴스
- **마운트·볼륨:** 호스트 파일 공유와 컨테이너 바깥 데이터 유지

### 개발 환경

| 항목 | 환경 및 확인 값 |
|---|---|
| 운영체제 | Windows (기존 README 기록: `Microsoft Windows [Version 10.0.26300.9711]`; 재실행 로그에는 Windows 버전 재조회 기록 없음) |
| 에디터 / 터미널 | VS Code / MSYS2 UCRT64 Bash |
| 로컬 프로젝트 | `C:\codyssey-week1\codyssey_project` (`/c/codyssey-week1/codyssey_project`) |
| Git | `git version 2.56.0.windows.4` |
| 브랜치 / 원격 | `main` / `origin = https://github.com/skypark-kr/codyssey_project.git` |
| Docker CLI 및 Engine | `29.9.2` / Docker Desktop `4.97.0` |
| Docker context / 서버 | `desktop-linux` / Linux on WSL2 (`6.18.54.1-microsoft-standard-WSL2`) |
| 웹 서버 이미지 | `codyssey-review-web:1.0` (`nginx:alpine` 기반) |
| 웹 서버 접근 | 호스트 `127.0.0.1:18080` → 컨테이너 `80/tcp`; 바인드 실습 `18081` |

### 평가 항목별 실습 근거 요약

| 번호 | 평가 영역 | 실제 확인한 증거 |
|---|---|---|
| 1 | 터미널 파일·디렉터리 작업 | `practice/review/demo.txt` 생성, 복사·이동·삭제 |
| 2 | Linux 파일 권한 | Ubuntu `stat`으로 `600/700 → 644/755` 확인 |
| 3 | Docker 설치·데몬 | `docker info`의 Server 및 `docker version` 확인 |
| 4 | hello-world | `Hello from Docker!`, `Exited (0)` |
| 5 | 이미지·컨테이너 관리 | `docker ps`, `exec`, `stats`, `stop`, `rm`, 이미지 태그 삭제 |
| 6 | Dockerfile 빌드 | `codyssey-review-web:1.0`, `Building 3.3s (8/8) FINISHED` |
| 7 | 포트·바인드 마운트 | `18080/18081` HTTP `200 OK`, 텍스트 수정 반영 |
| 8 | 볼륨 영속성 | `review-vol1` 삭제 후 `review-vol2`에서 같은 내용 출력 |
| 9 | Git/GitHub 설정 | `git remote -v`, `git branch -vv`, 기존 커밋 `d2dd4f3` |
| 10 | 프로젝트 구조 | `find`로 `.git` 제외한 소스 파일 목록 확인 |
| 11 | 재현 절차 | 별도 `review-repro-18082`의 HTTP `200 OK` |
| 12 | 이미지·컨테이너 분리 | 동일 이미지 ID, 서로 다른 컨테이너 ID 및 `NOT_FOUND` |
| 13 | 네트워크 격리·포트 전달 | 서로 다른 `net:[...]`, `bridge`, `18080 → 80` |
| 14 | 경로 구분 | `/c/...`, `site`, `cd ..`, 컨테이너의 `/usr/share/nginx/html` |
| 15 | 권한 숫자 의미 | `r=4, w=2, x=1`과 `stat`의 `644/755` |
| 16 | 포트 충돌 진단·해제 | `netstat :18080` LISTENING; 18082 종료 후 조회 결과 없음 |
| 17 | 볼륨 백업·복원 | `review-volume.tar`(2.5 KB), 새 볼륨에 복원·내용 확인 |
| 18 | 트러블슈팅·증거 | 오타·경로·옵션 오류의 실제 실패 및 수정 로그와 이미지 연결 |


## 1. 프로젝트 파일 구조

```text
codyssey_project/
├── README.md                    # 이 문서: 명령·실제 출력·설명·증거
├── Dockerfile                   # NGINX 기반 이미지 빌드 지시서
├── .gitignore                   # backup/ 백업 파일 제외 규칙
├── images/                      # 실습 스크린샷 22장
├── logs/                        # Docker 및 Git 상태의 텍스트 출력
│   ├── docker-bind.txt
│   ├── docker-containers.txt
│   ├── docker-images.txt
│   ├── docker-volumes.txt
│   └── git-remote.txt
├── practice.txt                 # 최초 터미널 실습 파일
├── hello.txt                    # 최초 터미널 실습 파일
├── practice/
│   ├── terminal/hello.txt       # 이전 실습의 중첩 폴더 생성 결과
│   └── review/demo.txt         # 이번 재실습의 파일 생성 결과
└── site/
    ├── index.html              # NGINX가 제공하는 HTML
    └── review.txt              # 바인드 마운트 변경 전후 검사 파일

# 로컬에만 존재하는 별도 폴더
backup/review-volume.tar        # .gitignore의 backup/ 규칙으로 제출 제외
```

- `README.md`는 실습의 설명과 재현 방법을 저장하므로 프로젝트 루트에 둔다.
- `Dockerfile`은 현재 폴더(`.`)를 빌드 컨텍스트로 사용하므로 소스와 함께 루트에 둔다.
- `site/`는 `COPY site/ /usr/share/nginx/html/`의 입력 경로다.
- `images/`와 `logs/`는 실습 증거 파일을 소스코드와 분리해 관리한다.
- `practice/`는 본 서비스 코드와 무관한 학습 결과를 분리한다.
- `backup/`은 실제 데이터의 백업 보관 위치로, 공개 소스 저장소에 올리지 않는다.

---

## 평가 01. 터미널에서 파일·폴더 생성, 복사, 이동, 삭제

**실행 환경:** Windows의 MSYS2 UCRT64 Bash, 프로젝트의 `practice/review` 폴더.

```bash
cd /c/codyssey-week1/codyssey_project
pwd
# /c/codyssey-week1/codyssey_project
mkdir -p practice/review
cd practice/review
touch demo.txt
echo "hello codyssey review" > demo.txt
cat demo.txt
# hello codyssey review
cp demo.txt copy.txt
mv copy.txt renamed.txt
ls -la
# demo.txt, renamed.txt 표시
mkdir temporary
mv renamed.txt temporary/
ls -la temporary
# renamed.txt 표시
rm temporary/renamed.txt
rmdir temporary
ls -la
# demo.txt만 남음
```

`mkdir -p`는 필요한 중간 폴더도 생성한다. `touch`는 파일을 만들거나 수정 시각을 갱신하고, `echo ... >`는 파일을 덮어쓸 수 있으므로 주의한다. `cp`는 복사, `mv`는 이름 변경 또는 이동, `rm`은 파일 삭제, `rmdir`은 **빈 폴더만** 삭제한다. `.`은 현재 폴더, `..`은 상위 폴더를 뜻한다.

**검증:** 최종 `ls -la`에서 `demo.txt`가 남고 `temporary`와 `renamed.txt`는 삭제된 것을 확인했다.

![평가 1: 파일 생성·복사·이동·삭제 실제 터미널](images/1.%20%ED%8F%B4%EB%8D%94%2C%20%ED%8C%8C%EC%9D%BC%20%EC%9D%B4%EB%8F%99%2C%20%EC%82%AD%EC%A0%9C.png)

## 평가 02. Ubuntu 파일·디렉터리 권한 변경

**실행 환경:** `review-permission`이라는 Ubuntu 컨테이너. 초기 시도에서 `/`에 `practive` 오타 폴더를 생성한 뒤 수정했고, 동일한 컨테이너 이름을 다시 사용하려다 충돌하여 기존 컨테이너를 삭제하고 재실행했다. 이후의 아래 로그가 최종 정상 실습이다.

```bash
# 호스트의 Bash에서 시작
docker run -it --name review-permission ubuntu bash

# Ubuntu 내부에서 실행
mkdir -p /practice
cd /practice
touch permission.txt
mkdir sample_dir
ls -ld permission.txt sample_dir
# -rw-r--r-- ... permission.txt
# drwxr-xr-x ... sample_dir

chmod 600 permission.txt
chmod 700 sample_dir
stat -c '%a %n' permission.txt sample_dir
# 600 permission.txt
# 700 sample_dir

chmod 644 permission.txt
chmod 755 sample_dir
stat -c '%a %n' permission.txt sample_dir
# 644 permission.txt
# 755 sample_dir
exit
```

`chmod`는 파일 **권한**을 변경하며 파일 **소유자**를 변경하는 명령은 아니다. 이번 실습에서는 `root:root` 소유자를 그대로 두고 접근 권한만 변경했다. 파일 `600`은 소유자만 읽기·쓰기를 허용하고, 폴더 `700`은 소유자만 읽기·쓰기·진입을 허용한다. `644/755`에서는 그룹과 다른 사용자에 대한 읽기(폴더는 진입 포함) 권한을 확장했다.

**검증:** 재실행 로그에 첫 번째 단계 `600/700`, 두 번째 단계 `644/755` 출력이 모두 기록되어 있다.

![평가 2: chmod 변경 전후 및 stat의 600·700·644·755](images/2.%20%EA%B6%8C%ED%95%9C%EB%B3%80%EA%B2%BD%20%ED%85%8C%EC%8A%A4%ED%8A%B8.png)

## 평가 03. Docker 설치 및 엔진(데몬) 상태 확인

```bash
docker --version
# Docker version 29.9.2, build a82e528

docker info
# Client: Version 29.9.2 / Context desktop-linux
# Server: Server Version 29.9.2 / Operating System Docker Desktop
# OSType linux / Architecture x86_64

docker version
# Client Version 29.9.2 (windows/amd64)
# Server Docker Desktop 4.97.0 / Engine 29.9.2 (linux/amd64)
```

`docker --version`은 CLI 버전만 알려 준다. `docker info`의 **Server** 항목이 실제로 조회되었으므로 클라이언트가 Docker 엔진과 통신할 수 있음을 확인했다. 운영체제는 Windows이지만 Docker Desktop을 통해 Linux 컨테이너를 실행한다.

![평가 3: Docker 실행 환경](images/3.%20docker%20version.png)
![평가 3: Docker Client 및 Server 버전](images/4.%20docker%20info.png)

## 평가 04. hello-world 컨테이너 실행 및 로그

```bash
docker run --name review-hello hello-world
# Hello from Docker!
# This message shows that your installation appears to be working correctly.

docker logs review-hello
# Hello from Docker!

docker ps -a
# review-hello ... Exited (0)
```

`docker run`은 이미지를 기반으로 컨테이너를 만들고 실행한다. `hello-world`는 성공 메시지를 출력한 뒤 정상 종료하기 때문에 `Exited (0)`은 오류가 아니다. `docker logs`로 종료된 컨테이너의 표준 출력도 다시 확인할 수 있었다.

![평가 4: hello-world 실행 성공](images/4.%20docker%20%EC%8B%A4%ED%96%89.png)
![이전 실습: hello-world 실행 화면](images/2.%20docker%EC%8B%A4%ED%96%89%EA%B2%B0%EA%B3%BC.png)

## 평가 05. 이미지·컨테이너 조회, 운영 및 정리

```bash
docker images
docker ps
docker ps -a

docker run -dit --name review-ops ubuntu bash
docker exec review-ops bash -lc 'pwd; ls; echo "Hello Ubuntu"'
# /
# ...
# Hello Ubuntu

docker stats --no-stream review-ops
# review-ops ... 0.00% CPU ... 4.609MiB / 3.752GiB ... 0.12%

docker stop review-ops
# review-ops
docker ps -a
# review-ops ... Exited (137)

docker rm review-ops
# review-ops

docker tag hello-world:latest codyssey-review-temp:1.0
docker images
# hello-world:latest 와 codyssey-review-temp:1.0 은 동일한 이미지 ID
docker image rm codyssey-review-temp:1.0
# Untagged: codyssey-review-temp:1.0
docker images
# codyssey-review-temp:1.0 태그가 사라짐
```

`docker images`는 이미지, `docker ps`는 실행 중인 컨테이너, `docker ps -a`는 종료된 컨테이너까지 보여 준다. `docker exec`는 실행 중인 컨테이너에서 명령을 실행하고, `docker stats`는 자원 사용량을 확인한다. 컨테이너 `review-ops`는 종료 후 삭제했으며, 별도로 만든 `codyssey-review-temp:1.0` **이미지 태그**도 제거했다. 이 작업이 원본 `hello-world` 이미지 자체 삭제까지 입증하는 것은 아니다.

**참고:** `review-ops`가 `Exited (137)`로 종료되었는데, 이번 재실행에서는 정확한 원인을 추가 진단하지 않았다. 종료 코드 137은 SIGKILL 종료와 관련되지만 이것만으로 메모리 부족이라고 단정하지 않는다.

![평가 5: 이미지 및 컨테이너 상태](images/5.%20docker%20%EC%97%B0%EB%8F%99.png)

## 평가 06. Dockerfile 작성과 커스텀 이미지 빌드

프로젝트 루트의 [`Dockerfile`](Dockerfile)에 작성한 실제 설정은 다음과 같다.

```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey_project"
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```

- `FROM nginx:alpine`: NGINX 웹 서버와 Alpine Linux 기반 이미지 선택
- `LABEL`: 이미지의 식별용 메타데이터 정의
- `COPY site/ /usr/share/nginx/html/`: 호스트의 웹 문서를 이미지 내부 NGINX 기본 문서 경로에 복사
- `EXPOSE 80`: 컨테이너에서 웹 서버가 사용하는 포트를 문서화. 실제 호스트 포트를 공개하는 명령은 아님

```bash
cd /c/codyssey-week1/codyssey_project
cat Dockerfile
cat site/index.html

docker build -t codyssey-review-web:1.0
# ERROR: docker: 'docker buildx build' requires 1 argument

docker build -t codyssey-review-web:1.0 .
# [+] Building 3.3s (8/8) FINISHED
# ... CACHED [1/2] FROM docker.io/library/nginx:alpine
# ... [2/2] COPY site/ /usr/share/nginx/html/
# ... naming to docker.io/library/codyssey-review-web:1.0

docker images
# codyssey-review-web:1.0 ... f940e09fa2ff ... 93.6MB
```

첫 번째 명령에서는 빌드 대상(컨텍스트)을 누락해 실패했다. 두 번째 명령의 마지막 `.`은 **현재 프로젝트 폴더를 빌드 컨텍스트로 사용**한다는 의미다. `-t`는 이미지 이름과 태그를 지정하며 `1.0`은 실습에 사용한 버전 표시다. `CACHED` 출력은 일부 빌드 단계를 캐시에서 재사용했음을 보여 준다. `--no-cache`는 캐시를 사용하지 않고 다시 빌드할 때 사용할 수 있으나 이번 재실행 로그에는 사용 기록이 없다.

![평가 6: Dockerfile 빌드 성공과 이미지 태그](images/6.%20docker%20image%20%EB%B9%8C%EB%93%9C.png)

## 평가 07. 웹 서버 포트 매핑 및 바인드 마운트 변경 반영

### 일반 컨테이너: 호스트 18080 → 컨테이너 80

```bash
docker run -d --name review-web-18080 -p 127.0.0.1:18080:80 codyssey-review-web:1.0
docker ps
# review-web-18080 ... 127.0.0.1:18080->80/tcp

curl -i http://localhost:18080
# HTTP/1.1 200 OK
# Server: nginx/1.31.8
# ...
# <h1> Hello, Codyssey! Bind Mount Updated!</h1>

docker logs review-web-18080
# Configuration complete; ready for start up
# GET / HTTP/1.1 ... 200
```

웹 브라우저 주소는 `http://localhost:18080`이다. `127.0.0.1:18080:80`을 지정해 이 PC의 로컬 인터페이스에서만 컨테이너의 80번 포트에 접근하도록 했다.

### 바인드 마운트 컨테이너: 호스트 18081 → 컨테이너 80

```bash
# 첫 시도: 쉼표 뒤 공백 때문에 실패
MSYS_NO_PATHCONV=1 docker run -d --name review-bind-18081 -p 127.0.0.1:18081:80 --mount "type=bind, source=C:/codyssey-week1/codyssey_project/site,target=/usr/share/nginx/html,readonly" codyssey-review-web:1.0
# invalid option 'source' ... option should not have whitespace

# 수정 후 성공
MSYS_NO_PATHCONV=1 docker run -d --name review-bind-18081 -p 127.0.0.1:18081:80 --mount "type=bind,source=C:/codyssey-week1/codyssey_project/site,target=/usr/share/nginx/html,readonly" codyssey-review-web:1.0

docker inspect --format '{{json .Mounts}}' review-bind-18081
# "Type":"bind", "Source":"C:/codyssey-week1/codyssey_project/site",
# "Destination":"/usr/share/nginx/html", "RW":false

curl -i http://localhost:18081
# HTTP/1.1 200 OK
```

### 재빌드 없이 파일 변경 반영

```bash
echo "Before bind mount" > site/review.txt
curl http://localhost:18081/review.txt
# Before bind mount

echo "After bind mount" > site/review.txt
curl http://localhost:18081/review.txt
# After bind mount
```

**결론:** 새 이미지를 빌드하거나 컨테이너를 재시작하지 않아도 호스트 `site/review.txt`의 변경 내용이 컨테이너 NGINX 응답에 즉시 반영되었다. `readonly`는 **컨테이너 측 쓰기 금지**이며 호스트에서 수정한 파일을 읽는 것까지 막지는 않는다. `MSYS_NO_PATHCONV=1`은 MSYS2 Bash가 `/usr/share/nginx/html` 같은 리눅스 경로를 Windows 경로로 잘못 변환하는 일을 방지한다.

**과거 실습과의 구분:** 아래 8080·8081 HTML 화면은 이전 실습에 촬영한 스크린샷이다. 위의 18080·18081 및 `review.txt` 검증은 이번 재실행 로그에 기록된 내용이다.

![이전 실습의 호스트 8080 웹페이지](images/3.dockerfile%288080%29.png)
![이전 실습의 바인드 마운트 변경 전 8081 페이지](images/4.dockerfile%288081%29.png)
![이전 실습의 바인드 마운트 HTML 변경 후](images/5.dockerfile%28mount%29.png)
![평가 7: 재실행 바인드 마운트 변경 전 텍스트](images/7-1.%20%EB%B0%94%EC%9D%B8%EB%93%9C%EB%A7%88%EC%9A%B4%ED%8A%B8%20%EC%A0%84.png)
![평가 7: 재실행 바인드 마운트 변경 후 텍스트](images/7-2.%20%EB%B0%94%EC%9D%B8%EB%93%9C%EB%A7%88%EC%9A%B4%ED%8A%B8%20%ED%9B%84.png)

## 평가 08. 이름 있는 볼륨의 데이터 영속성

컨테이너 내부의 일반 파일은 컨테이너를 삭제하면 함께 사라질 수 있다. 반면 **이름 있는 볼륨(named volume)**은 컨테이너의 생명주기와 분리되어 관리할 수 있다.

```bash
docker volume create codyssey-review-data
# codyssey-review-data

docker volume ls
# local codyssey-data
# local codyssey-review-data

MSYS_NO_PATHCONV=1 docker run -d --name review-vol1 --mount type=volume,source=codyssey-review-data,target=/data ubuntu sleep infinity
MSYS_NO_PATHCONV=1 docker exec review-vol1 sh -c 'echo "Codyssey Review Voulme Test" > data/hello.txt'
MSYS_NO_PATHCONV=1 docker exec review-vol1 cat /data/hello.txt
# Codyssey Review Voulme Test

docker rm -f review-vol1
# review-vol1

docker volume ls
# local codyssey-review-data (유지됨)

MSYS_NO_PATHCONV=1 docker run -d --name review-vol2 --mount type=volume,source=codyssey-review-data,target=/data ubuntu sleep infinity
MSYS_NO_PATHCONV=1 docker exec review-vol2 cat /data/hello.txt
# Codyssey Review Voulme Test

docker volume inspect codyssey-review-data
# "Name": "codyssey-review-data"
# "Mountpoint": "/var/lib/docker/volumes/codyssey-review-data/_data"
```

**실제 출력의 `Voulme`는 실습 시 입력한 `Volume`의 철자 오타다.** 보고서에서는 검증의 정확성을 위해 원문을 그대로 보존했다. 이때 `sh -c`의 상대 경로 `data/hello.txt`는 Ubuntu 컨테이너의 기본 현재 위치 `/`를 기준으로 `/data/hello.txt`를 의미했다. 재현 시에는 명확한 절대 경로 `/data/hello.txt` 사용을 권장한다.

**검증:** `review-vol1`을 삭제한 뒤 `review-vol2`에서 같은 텍스트가 출력돼 볼륨 영속성이 입증되었다.

![평가 8: 첫 번째 볼륨 컨테이너에서 데이터 기록·조회](images/8.%20%EC%98%81%EC%86%8D%EC%84%B1%20%ED%99%95%EC%9D%B81.png)
![평가 8: 컨테이너 삭제 후 새 컨테이너의 데이터 조회](images/8-2.%20%EC%98%81%EC%86%8D%EC%84%B1%20%ED%99%95%EC%9D%B82.png)

## 평가 09. Git 환경 설정 및 GitHub 원격 저장소 확인

```bash
git --version
# git version 2.56.0.windows.4

git config --get user.name
# (설정된 Git 작성자 이름 출력)
git config --get init.defaultBranch
# main

git remote -v
# origin https://github.com/skypark-kr/codyssey_project.git (fetch)
# origin https://github.com/skypark-kr/codyssey_project.git (push)

git branch -vv
# * main d2dd4f3 [origin/main] Update README with Docker practice

git status
# On branch main
# Your branch is up to date with 'origin/main'.
# Untracked files: practice/review/, site/review.txt

git log -1 --oneline
# d2dd4f3 ... Update README with Docker practice

git --no-pager config --list
# Git 설정 목록 출력 (원본에는 이메일이 포함되므로 공개 문서에는 미기재)
```

Git은 로컬 파일의 변경 이력을 관리하고, GitHub는 그 변경 이력을 원격 저장소에 보관하는 서비스이다. `git status`에서 `Untracked files`는 새로운 파일이 아직 Git 관리 대상으로 등록되지 않았다는 뜻이다. `git add`(변경사항 선택) → `git commit -m ...`(로컬 커밋 기록) → `git push origin main`(원격 업로드) 순으로 진행한다.

**검증 범위:** 재실행 로그에서 GitHub 원격 연동과 **이전에 만들어진 커밋**은 확인되었다. 재실습에서 만든 새 `README.md`·`review.txt`·이미지·로그를 새로 `git push`한 최종 성공 로그는 첨부되지 않았다. 마지막 단계에서 새 커밋·푸시를 수행해야 한다.

![평가 9: Git 버전·원격 저장소 및 상태 조회](images/9.%20git%20version%20%EB%93%B1.png)
![기존 실습: VS Code의 GitHub 계정 연동](images/1.git-hub%EC%97%B0%EB%8F%99.png)
![기존 실습: Git 설정 화면(개인정보 가림)](images/1-2.%20gitconfig.png)

## 평가 10. 디렉터리 구성과 파일 배치 기준

```bash
cd /c/codyssey-week1/codyssey_project
pwd
ls -la
find . -path './.git' -prune -o -type f -print
```

실제 파일 목록에는 `Dockerfile`, `README.md`, `images/*.png`, `site/index.html`, `site/review.txt`, `practice/review/demo.txt` 등이 표시되었다. `find`의 `-prune`은 `.git/` 내부의 수많은 관리 파일을 생략하기 위해 사용하였다.

**구조 설계:** 실행용 소스(`site/`)와 연습용 파일(`practice/`), 설명 문서(`README.md`), 실행 증거(`images/`, `logs/`)를 분리했다. 이로써 미션을 다시 수행할 때 입력 파일과 출력 증거를 구분할 수 있다. `.git/`은 Git이 자동 관리하는 저장소 메타데이터이므로 수동으로 편집하지 않는다.

## 평가 11. 명령어를 통한 재현 가능성

이미 생성한 `codyssey-review-web:1.0` 이미지로 **별도의 웹 컨테이너**를 실행하여 서비스를 재현했다.

```bash
docker run -d --name review-repro-18082 -p 127.0.0.1:18082:80 codyssey-review-web:1.0
# 새 컨테이너 ID 출력

docker ps
# review-repro-18082 ... 127.0.0.1:18082->80/tcp

curl -i http://localhost:18082
# HTTP/1.1 200 OK
# <h1> Hello, Codyssey! Bind Mount Updated!</h1>

docker logs review-repro-18082
# ... Configuration complete; ready for start up
# ... GET / HTTP/1.1 ... 200
```

같은 이미지에서 생성한 새 컨테이너가 다른 호스트 포트에서 정상 동작하는 것을 확인했다. 이미지 빌드는 `docker build -t 이름:태그 .`로 수행하며, 다른 컴퓨터에서는 Docker 설치 후 저장소를 복제해 동일한 Dockerfile과 `site/`를 사용할 수 있다. **이미 존재하는 컨테이너 이름과 호스트 포트는 중복 사용할 수 없으므로** 재현 시 이름·포트를 변경하거나 기존 실습용 컨테이너를 먼저 종료해야 한다.

## 평가 12. Docker 이미지와 컨테이너의 구분·격리

```bash
docker image inspect codyssey-review-web:1.0 --format 'ImageID={{.Id}}'
# ImageID=sha256:f940e09fa2ff43028a797e6c7dee5845057f880ef1328a5a084d3cd47257eeda

docker inspect review-web-18080 --format 'ContainerID={{.Id}} ImageID={{.Image}}'
# ContainerID=ecdb3f8c7cfe... ImageID=sha256:f940e09fa2ff...

docker inspect review-bind-18081 --format 'ContainerID={{.Id}} ImageID={{.Image}}'
# ContainerID=7bbbf5de408a... ImageID=sha256:f940e09fa2ff...

docker exec review-web-18080 sh -c 'echo "only in containerA" > /tmp/only-A.txt'
docker exec review-bind-18081 sh -c 'test -e /tmp/only-A.txt && echo FOUND || echo NOT_FOUND'
# NOT_FOUND
```

두 컨테이너는 **동일한 이미지 ID**로 생성되었지만 컨테이너 ID가 달랐다. 첫 번째 컨테이너의 `/tmp`에 만든 파일은 두 번째 컨테이너에서 발견되지 않았다. 이미지는 실행 환경의 원본이고, 컨테이너는 원본에서 생성된 각각의 인스턴스임을 실험으로 확인했다. 단, 볼륨/바인드 마운트로 연결한 경로는 공유될 수 있으므로 모든 파일이 항상 분리되는 것은 아니다.

![평가 12: 같은 이미지, 다른 컨테이너 및 임시 파일 격리](images/12.%20%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88%EB%B6%84%EB%A6%AC.png)

## 평가 13. 네트워크 네임스페이스 및 포트 포워딩 원리

Docker의 일반적인 브리지 네트워크는 컨테이너마다 네트워크 인터페이스·주소·라우팅 등의 네트워크 자원을 격리하는 Linux 네트워크 네임스페이스를 사용한다.

```bash
docker network ls
# bridge / host / none

docker inspect --format 'NetworkMode={{.HostConfig.NetworkMode}}' review-web-18080
# NetworkMode=bridge

docker port review-web-18080
# 80/tcp -> 127.0.0.1:18080

MSYS_NO_PATHCONV=1 docker exec review-web-18080 readlink /proc/self/ns/net
# net:[4026532682]

MSYS_NO_PATHCONV=1 docker exec review-bind-18081 readlink /proc/self/ns/net
# net:[4026532758]

docker port review-web-18080
# 80/tcp -> 127.0.0.1:18080

curl -I http://localhost:18080
# HTTP/1.1 200 OK
```

네트워크 네임스페이스 식별자가 서로 달라 두 컨테이너의 네트워크가 구분된다는 점을 확인했다. 컨테이너의 NGINX는 내부 80번 포트에서 동작하며, `-p 127.0.0.1:18080:80` 설정을 통해 호스트의 로컬 18080번 포트로 들어온 요청이 전달된다. Docker Desktop의 Windows ↔ Linux 컨테이너 포트 연결을 통해 `localhost:18080`에서 HTTP `200 OK`를 확인했다.

```text
브라우저/호스트: http://127.0.0.1:18080
    ↓ Docker Desktop의 포트 게시·전달
컨테이너 네트워크 네임스페이스
    ↓ 내부 TCP 80번 포트
NGINX → HTTP/1.1 200 OK
```

여기서 `EXPOSE 80`은 Dockerfile의 메타데이터이고, **호스트에 실제로 포트를 게시하는 것은 `docker run -p`**이다.

![평가 13: bridge, 다른 네임스페이스 ID와 포트 연결](images/13.%20%ED%8F%AC%ED%8A%B8%20%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC%20%ED%99%95%EC%9D%B8.png)

## 평가 14. 절대·상대 경로와 호스트/컨테이너 경로

```bash
cd /c/codyssey-week1/codyssey_project
pwd
# /c/codyssey-week1/codyssey_project
ls -ld site
cd site
pwd
# /c/codyssey-week1/codyssey_project/site
cd ..
pwd
# /c/codyssey-week1/codyssey_project

MSYS_NO_PATHCONV=1 docker exec review-web-18080 sh -c 'pwd; ls -la /usr/share/nginx/html'
# /
# ... index.html
```

호스트의 `/c/codyssey-week1/codyssey_project`는 프로젝트의 절대 경로이며, `site`는 현재 위치에 따라 달라지는 상대 경로다. `..`은 상위 폴더 하나를 뜻한다. `/usr/share/nginx/html`은 **컨테이너 내부** NGINX의 기본 문서 경로로, Windows의 `C:\...` 경로와 같은 공간이 아니다. Dockerfile의 `COPY`는 호스트 소스를 **이미지 제작 시점에 복사**하는 것이고, `--mount type=bind`는 호스트의 기존 폴더를 **실행 중 컨테이너에 연결**하는 방식이다.

## 평가 15. rwx 권한 비트와 숫자 계산

Linux 접근 권한에서 `r=4`(읽기), `w=2`(쓰기), `x=1`(실행·디렉터리 진입)이며 각 범주의 값은 더해서 계산한다.

| 숫자 | 소유자(owner) | 그룹(group) | 기타(others) | 합계 계산 |
|---|---|---|---|---|
| `644` | `rw-` = 6 | `r--` = 4 | `r--` = 4 | `4+2`, `4`, `4` |
| `755` | `rwx` = 7 | `r-x` = 5 | `r-x` = 5 | `4+2+1`, `4+1`, `4+1` |

```bash
MSYS_NO_PATHCONV=1 docker run --rm ubuntu bash -lc 'touch /tmp/p.txt; mkdir /tmp/d; chmod 644 /tmp/p.txt; chmod 755 /tmp/d; stat -c "%a %n" /tmp/p.txt /tmp/d'
# 644 /tmp/p.txt
# 755 /tmp/d
```

`--rm`은 일회용 컨테이너 실행이 끝나면 컨테이너를 자동 삭제한다. 이 명령은 권한이 적용되었다는 출력만 확인하며, 실제로 각 사용자로 접속해 접근 가능 여부를 시험한 기록은 없다.

## 평가 16. 포트 점유 진단과 안전한 해제

Windows 환경이므로 `netstat.exe`를 이용하였다.

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}'
# review-repro-18082 ... 127.0.0.1:18082->80/tcp
# review-web-18080   ... 127.0.0.1:18080->80/tcp

docker port review-web-18080
# 80/tcp -> 127.0.0.1:18080

netstat.exe -ano | grep ':18080'
# TCP 127.0.0.1:18080 0.0.0.0:0 LISTENING 11136

docker port review-repro-18082
# 80/tcp -> 127.0.0.1:18082

docker stop review-repro-18082
# review-repro-18082
docker rm review-repro-18082
# review-repro-18082

netstat.exe -ano | grep ':18082'
# 출력 없음 (해당 시점에 일치하는 연결 항목 없음)
```

포트가 이미 사용 중인 경우 `docker ps`에서 포트를 게시한 컨테이너를 찾고, `netstat`으로 Windows 측 `LISTENING` 상태와 PID를 확인한다. 실습에서 사용한 `review-repro-18082`가 불필요하므로 해당 컨테이너를 중지·삭제한 뒤 재조회했다. 다른 응용 프로그램의 포트를 강제로 종료하지 않고 Docker 소유자를 먼저 식별하는 것이 안전하다. 기존 서비스가 필요하다면 새 컨테이너 실행 시 사용하지 않는 호스트 포트를 골라야 한다.

**검증의 한계:** 이 로그에는 실제 `port is already allocated` 오류를 고의로 발생시킨 기록은 없다. 다만 포트 사용 확인과 해제 후 재조회는 실제로 수행했다.

![평가 16: 포트 상태 진단, 컨테이너 중지·삭제 후 확인](images/16.%20%ED%8F%AC%ED%8A%B8%20%EC%82%AD%EC%A0%9C.png)

## 평가 17. Docker 볼륨 데이터의 백업 및 복원

볼륨 영속성은 *컨테이너 삭제 후에도 같은 볼륨이 유지되는가*를 확인하는 것이고, 백업·복원은 *별도 파일로 저장한 데이터를 다른 볼륨에 다시 가져올 수 있는가*를 확인한다.

### 17-1. 실제 데이터를 tar 아카이브로 백업

```bash
cd /c/codyssey-week1/codyssey_project
mkdir -p backup

docker volume ls
# codyssey-data, codyssey-review-data

# 첫 명령에서는 target=/dat 오타 및 잘못된 호스트 경로로 실패함
# 성공한 수정 명령:
MSYS_NO_PATHCONV=1 docker run --rm --mount "type=volume,source=codyssey-review-data,target=/data,readonly" --mount "type=bind,source=C:/codyssey-week1/codyssey_project/backup,target=/backup" alpine sh -c 'cd /data && tar -cf /backup/review-volume.tar .'

ls -lh backup/review-volume.tar
# -rw-r--r-- ... 2.5K ... backup/review-volume.tar
```

원본 볼륨은 `readonly`로 마운트해 백업 중 실수로 수정하지 않도록 했다. Alpine 임시 컨테이너가 `/data`의 파일들을 `tar` 아카이브로 압축하지 않은 묶음 파일(`review-volume.tar`)로 기록한다. 호스트의 `backup/` 폴더에 아카이브가 남는다.

### 17-2. 새 볼륨에 복원 후 비교

```bash
docker volume create codyssey-review-restored
# codyssey-review-restored

docker volume ls
# codyssey-data
# codyssey-review-data
# codyssey-review-restored

MSYS_NO_PATHCONV=1 docker run --rm --mount "type=volume,source=codyssey-review-restored,target=/data" --mount "type=bind,source=C:/codyssey-week1/codyssey_project/backup,target=/backup,readonly" alpine sh -c 'cd /data && tar -xf /backup/review-volume.tar'

MSYS_NO_PATHCONV=1 docker run --rm --mount "type=volume,source=codyssey-review-restored,target=/data,readonly" alpine cat /data/hello.txt
# Codyssey Review Voulme Test
```

**검증:** 별도 볼륨 `codyssey-review-restored`에서 원래 텍스트를 동일하게 읽었다. 이때 백업한 데이터의 철자 `Voulme`까지 그대로 재현됐다. 원본 볼륨을 삭제하지 않았고, 실습용 백업을 GitHub에 공개할 필요가 없으므로 `.gitignore`에 `backup/` 제외 규칙을 추가했다.

```bash
echo "backup/" >> .gitignore
# 재실행 로그에서 .gitignore가 Untracked로 나타났음
```

**운영 시 고려사항:** 이번 테스트는 단일 텍스트 파일에 대한 정적 백업이다. 실제 데이터베이스/변경 중인 볼륨의 일관성 있는 백업, 백업 파일의 외부 보관, 주기적인 복원 테스트는 별도의 운영 절차가 필요하다.

![평가 17: tar 백업 아카이브 생성 및 새 볼륨 복원 검증](images/17.%20%EB%B0%B1%EC%97%85.png)

## 평가 18. 실제 오류 사례와 문제 해결 기록

아래 내용은 재실행 로그에서 확인된 오류를 중심으로 작성했다. 단순 오류 메시지를 숨기지 않고 **문제 → 원인 → 수정 → 검증** 순서로 정리했다.

| 실제 오류 또는 관찰 | 원인·확인 | 해결 명령 및 검증 |
|---|---|---|
| `cd/practice: No such file or directory`, `mkdir practive` | 명령어의 공백·폴더 철자 오류 | `mkdir -p /practice`, `cd /practice`; 이후 권한 실습 성공 |
| `container name ... review-permission ... already in use` | 이전 컨테이너가 `exit` 후에도 존재 | `docker rm review-permission` 후 새 컨테이너 실행, 권한 변경 검증 |
| `ls_ld: command not found`, `sample dir` | 명령·폴더명에 잘못된 공백과 `_` | `ls -ld permission.txt sample_dir`에서 두 항목 출력 |
| `stat -c '% 'n' ...` 뒤의 `>` 대기 | 따옴표를 닫지 못해 Bash가 명령의 끝을 기다림 | `Ctrl+C`로 취소, `stat -c '%a %n' ...` 실행 성공 |
| `docker buildx build requires 1 argument` | Docker 빌드 컨텍스트 `.` 누락 | `docker build -t codyssey-review-web:1.0 .` → `FINISHED` |
| `cat: Dockerfile: No such file or directory` | `codyssey_project` 상위 폴더에서 조회 | 프로젝트 루트로 `cd`, 이후 Dockerfile 출력 |
| `--mount`에서 `option should not have whitespace` | `type=bind, source=`에 불필요한 공백 | `type=bind,source=...`로 수정, `Type=bind`, `RW=false` 확인 |
| 작은따옴표 미종결, 명령 앞의 `$` | Bash 프롬프트 문자를 명령어로 입력 | `Ctrl+C` 취소 후 `$` 없이 정상 명령 실행 |
| 볼륨 작성 명령의 `Voulme`, `data/hello.txt` | 문자 오타와 상대 경로 사용 | 실제 출력도 오타 그대로 유지, 영속성·복원 내용 일치 확인 |
| 백업 시 `can't cd to /data` | 마운트 `target=/dat` 오타 및 호스트 경로 오타 | `target=/data`, 올바른 `C:/.../backup`으로 수정해 2.5KB tar 생성 |
| `docker voulme`, `docker prot`, `docekr` | 명령어 철자 오류 | `docker volume`, `docker port`, `docker ps`로 재시도 성공 |
| `cd . .` → `too many arguments` | 상위 폴더 표기 `..`를 띄어 씀 | `cd ..`로 프로젝트 폴더 복귀 |
| `review-ops` → `Exited (137)` | 강제 종료와 관련된 종료 코드 | 종료 상태 관찰만 있음. 원인은 추가 확인 전까지 미확정 |

### 텍스트 증거 파일

이번 재실행에서는 터미널 출력 중 일부를 아래 파일로 별도 저장하였다.

- [`logs/docker-images.txt`](logs/docker-images.txt): 이미지 목록
- [`logs/docker-containers.txt`](logs/docker-containers.txt): 컨테이너 목록 및 상태
- [`logs/docker-volumes.txt`](logs/docker-volumes.txt): 볼륨 목록
- [`logs/docker-bind.txt`](logs/docker-bind.txt): 바인드 마운트 대상·읽기 전용 여부
- [`logs/git-remote.txt`](logs/git-remote.txt): GitHub 원격 저장소 주소

이 로그 파일은 **상태 출력의 스냅샷**이며, 전체 명령어 이력은 본 README의 섹션별 실제 실행 요약과 별도 원본 재실행 로그를 근거로 한다. 원본 전체 로그에는 개인 설정이 포함될 수 있어 여기에는 복사하지 않았다.

---

## 재현 방법 (Windows + MSYS2 UCRT64 Bash)

다음 예시는 **이미 존재하는 실습 컨테이너와 포트의 충돌을 피하기 위해 별도의 이름과 19080번 포트**를 사용한다. Docker Desktop이 실행된 상태여야 한다.

```bash
# 새로운 컴퓨터에서 클론했을 경우
# git clone https://github.com/skypark-kr/codyssey_project.git
# cd codyssey_project

# 기존에 프로젝트가 있는 컴퓨터에서는 다음 경로로 이동
cd /c/codyssey-week1/codyssey_project

# 이미지 빌드 및 웹 서비스 실행
docker build -t codyssey-reproduce:1.0 .
docker run -d --name codyssey-reproduce-19080 -p 127.0.0.1:19080:80 codyssey-reproduce:1.0
curl -i http://localhost:19080
# HTTP/1.1 200 OK 및 HTML 내용 확인

# 실습 후 해당 재현용 컨테이너만 정리
docker stop codyssey-reproduce-19080
docker rm codyssey-reproduce-19080
```

### 바인드 마운트 재현 예시 (경로 수정 필요)

```bash
# Windows Git Bash에서는 source=를 실제 프로젝트 절대 경로로 변경
MSYS_NO_PATHCONV=1 docker run -d --name codyssey-reproduce-bind -p 127.0.0.1:19081:80 --mount "type=bind,source=C:/codyssey-week1/codyssey_project/site,target=/usr/share/nginx/html,readonly" codyssey-reproduce:1.0
curl -i http://localhost:19081
```

컨테이너를 새로 실행하는 명령이므로 해당 이름이 이미 존재한다면 중복 실행하지 않아야 한다. `docker ps -a`로 먼저 확인한다. `backup/` 폴더를 다른 PC에서도 복원하려면 실제 백업 파일을 별도로 안전하게 옮겨야 한다. 이 저장소의 `.gitignore`는 해당 폴더를 공개 커밋에서 제외한다.

---

## 학습 정리

이번 재실습에서 파일 시스템 경로와 터미널 명령어의 공백·따옴표를 구분하는 것이 중요함을 확인했다. Git은 로컬 소스 변경을 기록·공유하며, Docker는 이미지와 컨테이너를 분리해 실행 환경을 재현한다. 바인드 마운트는 개발 중 호스트 파일 변경을 즉시 반영하고, 이름 있는 볼륨은 컨테이너 교체 후에도 데이터를 보존한다. 여기에 포트 전달, 네트워크 격리, 볼륨 백업·복원을 추가해 실제 실습 결과에 근거한 재현 가능한 개발 환경 문서를 완성했다.
