Codyssey 1주차 미션 - 내 컴퓨터에 개발자용 '작업실' 꾸미기

## 1. 프로젝트 개요(미션 목표 요약)

- 리눅스 CLI(터미널), Docker(컨테이너), Git/GitHub(버전 관리 및 협업) 세팅
- 터미널로 작업 디렉토리와 권한을 정리한 뒤, Docker를 설치 및 점검하고 컨테이너를 실행/관리
- 간단한 웹 서버를 Dockerfile로 컨테이너화하고, 포트 매핑으로 접속을 확인하며, 바인드 마운트/볼륨으로 "변경 반영"과 "데이터 영속성"을 직접 검증
- 실행 결과(로그/접속/데이터 유지)로 핵심 흐름을 확인
- 이미지와 컨테이너의 분리, 격리된 실행 환경, 포트·스토리지 연결 방식이라는 구조적 원칙을 적용

## 2. 실행 환경(OS/쉘/터미널, Docker 버전, Git 버전)
- OS : Microsoft Windows [Version 10.0.26300.9711]
- Terminal/Shell : MSYS2 **UCRT64 Bash**
- Docker version : Docker version 29.9.2, build a82e528
- Git version : git version 2.56.0.windows.4

## 3. 수행 항목 체크리스트
- [x] `pwd`, `ls -la`, `cd`로 위치·파일 목록 확인
- [x] `mkdir`, `touch`, `echo`, `cat`, `cp`, `mv`, `rm`, `rmdir`로 파일·폴더 조작
- [x] Ubuntu 컨테이너에서 **파일과 디렉터리의 권한 변경** (`600→644`, `700→755`)
- [x] `docker --version`, `docker info`로 Docker 설치·엔진 동작 확인
- [x] `docker images`, `docker ps`, `docker ps -a`, `docker logs`, `docker stats` 실행
- [x] `hello-world` 실행 및 성공 메시지 확인
- [x] Ubuntu 컨테이너 내부 진입(`run -it`, `start -ai`) 및 명령 실행(`exec`)
- [x] NGINX 베이스로 **Dockerfile 직접 작성** 및 커스텀 이미지 빌드
- [x] 포트 매핑 후 **8080 웹페이지 접속 성공** (사용자 확인)
- [x] **8081 바인드 마운트** 연결(`Type=bind`, `RW=false`)과 HTML 수정 전후 반영 확인
- [x] **Docker 볼륨 영속성**: 컨테이너 삭제 후 새 컨테이너에서 같은 파일 확인
- [x] Git 커밋 및 GitHub 원격 푸시


### 4-1. 현재 위치 확인과 폴더 이동

```bash
$ pwd
/c/codyssey-week1

$ ls -la
total 8
drwxr-xr-x 1 siest 197121 0 11월  1 20:24 ./
drwxr-xr-x 1 siest 197121 0 11월  1 21:01 ../
drwxr-xr-x 1 siest 197121 0 11월  1 20:24 codyssey_project/

$ cd codyssey_project
```

- `pwd`: 현재 폴더 경로를 출력한다.
- `ls -la`: 숨김 항목을 포함한 상세 목록을 출력한다.
- `cd`: 경로를 이동한다.
- **절대 경로**는 `/c/codyssey-week1/codyssey_project`처럼 시작 위치부터 나타낸다.
- **상대 경로**는 `cd codyssey_project`처럼 현재 폴더를 기준으로 나타낸다. `.`은 현재 폴더, `..`은 상위 폴더다.

### 4-2. 파일 생성·내용 확인·복사·이름 변경·삭제

```bash
$ touch practice.txt
$ echo "Hello World" > practice.txt
$ cat practice.txt
Hello World

$ cp practice.txt hello.txt
$ mv hello.txt renamed.txt
$ ls -la
# 출력 목록에서 renamed.txt 존재 확인
$ rm renamed.txt
$ ls -la
# 출력 목록에서 renamed.txt 삭제 확인
```

`touch`는 빈 파일을 만들고, `echo ... >`는 내용을 파일에 기록한다(기존 내용 덮어쓰기 가능). `cp`는 복사, `mv`는 이동 또는 이름 변경, `rm`은 파일 삭제를 수행한다. 

### 4-3. 폴더 생성·파일 이동·빈 폴더 삭제

```bash
$ mkdir backup
$ mv practice.txt backup/
$ ls -la backup
-rw-r--r-- 1 siest 197121 12 11월  1 21:37 practice.txt

$ mv backup/practice.txt .
$ rmdir backup
$ ls -la
# 프로젝트 폴더에 practice.txt가 다시 존재함을 확인
```

### 4-4. 실습용 하위 폴더 생성

```bash
$ mkdir -p practice/terminal
$ echo "Hello Codyssey!" > practice/terminal/hello.txt
$ git add practice/
warning: in the working copy of 'practice/terminal/hello.txt', LF will be replaced by CRLF the next time Git touches it
```

`mkdir -p`는 중간 경로를 포함해 폴더를 생성한다. LF/CRLF 메시지는 Windows의 줄바꿈 변환 관련 **경고**이며, 뒤의 커밋은 성공했다.

## 5. Git / GitHub 버전 관리

### 5-1. 상태 확인과 첫 번째 커밋

```bash
$ git status
On branch main
Your branch is up to date with 'origin/main'.
# 수정된 README.md를 확인

$ git commit -m "Update README"
[main 3a1d23c] Update README
 1 file changed, 5 insertions(+), 5 deletions(-)

$ git push
To https://github.com/skypark-kr/codyssey_project.git
   a10297c..3a1d23c  main -> main
```

### 5-2. 실습 파일 커밋·푸시

```bash
$ git diff --cached --stat
 README.md                   | 22 +++++++++++-----------
 practice.txt                |  1 +
 practice/terminal/hello.txt |  1 +
 3 files changed, 13 insertions(+), 11 deletions(-)

$ git commit -m "Complete terminal practice"
[main 418fa8d] Complete terminal practice
 3 files changed, 13 insertions(+), 11 deletions(-)
 create mode 100644 practice.txt
 create mode 100644 practice/terminal/hello.txt

$ git push origin main
To https://github.com/skypark-kr/codyssey_project.git
   3a1d23c..418fa8d  main -> main
```

- **Git:** 내 컴퓨터에서 파일 변경 이력을 관리한다.
- **GitHub:** 원격 저장소에 변경 이력을 보관하고 공유한다.
- `git add` → `git commit` → `git push` 순서로 진행했다.

관련 커밋: [README 변경 `3a1d23c`](https://github.com/skypark-kr/codyssey_project/commit/3a1d23c) · [터미널 실습 `418fa8d`](https://github.com/skypark-kr/codyssey_project/commit/418fa8d)

---

## 6. Ubuntu 컨테이너 및 Linux 파일 권한 실습

### 6-1. Ubuntu 실행 및 내부 진입

```bash
$ docker run -it --name permission-test ubuntu bash
root@e821beb07cf8:/# mkdir -p /practice
root@e821beb07cf8:/# cd /practice
root@e821beb07cf8:/practice# touch permission.txt
root@e821beb07cf8:/practice# mkdir sample_dir
```

이 실습의 `/practice`는 **Ubuntu 컨테이너 내부 경로**이고, Windows 호스트의 Git 프로젝트 경로가 아니다.

### 6-2. 권한 변경 전과 후

**변경 전 실제 출력:**

```bash
root@e821beb07cf8:/practice# ls -ld permission.txt sample_dir
-rw-r--r-- 1 root root    0 Nov  2 15:02 permission.txt
drwxr-xr-x 2 root root 4096 Nov  2 15:02 sample_dir
```

**첫 번째 변경:**

```bash
root@e821beb07cf8:/practice# chmod 600 permission.txt
root@e821beb07cf8:/practice# chmod 700 sample_dir
root@e821beb07cf8:/practice# ls -ld permissio.txt, sample_dir
ls: cannot access 'permissio.txt,': No such file or directory
drwx------ 2 root root 4096 Nov  2 15:02 sample_dir
```

디렉터리 `700` 변경은 출력으로 확인했다. 

**두 번째 변경과 최종 검증:**

```bash
root@e821beb07cf8:/practice# chmod 644 permission.txt
root@e821beb07cf8:/practice# chmod 755 sample_dir
root@e821beb07cf8:/practice# ls -ld permission.txt sample_dir
-rw-r--r-- 1 root root    0 Nov  2 15:02 permission.txt
drwxr-xr-x 2 root root 4096 Nov  2 15:02 sample_dir

root@e821beb07cf8:/practice# stat -c '%a %n' permission.txt sample_dir
644 permission.txt
755 sample_dir
```

**권한 의미**

| 숫자 | 파일/폴더 소유자 | 그룹 | 기타 사용자 |
|---|---|---|---|
| `600` | 읽기·쓰기 | 권한 없음 | 권한 없음 |
| `644` | 읽기·쓰기 | 읽기 | 읽기 |
| `700` | 읽기·쓰기·실행(폴더 진입) | 권한 없음 | 권한 없음 |
| `755` | 읽기·쓰기·실행(폴더 진입) | 읽기·실행 | 읽기·실행 |

`r=4`, `w=2`, `x=1`의 합으로 각 자리 숫자를 표현한다. 폴더의 `x`는 그 폴더를 통과하거나 진입할 수 있는 권한과 관련된다.

### 6-3. 컨테이너 종료·재진입

```bash
root@e821beb07cf8:/practice# exit
exit

$ docker start -ai permission-test
root@e821beb07cf8:/#
```

기존 컨테이너를 **삭제하지 않고 다시 시작**했을 때 같은 컨테이너에 재진입할 수 있었다.

---

## 7. Docker 설치 및 기본 운영

### 7-1. 설치·서버 동작 확인

```bash
$ docker --version
Docker version 29.9.2, build a82e528

$ docker info
Client:
 Version:    29.9.2
 Context:    desktop-linux
Server:
 Server Version: 29.9.2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
```

### 7-2. 이미지 목록과 컨테이너 목록

```bash
$ docker images
IMAGE                ID             DISK USAGE
hello-world:latest   c567b231f656       25.9kB
ubuntu:latest        6a06111c3b0a        163MB

$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

$ docker ps -a
CONTAINER ID   IMAGE         STATUS                     NAMES
e821beb07cf8   ubuntu        Exited (0) ...             permission-test
243fe8266709   ubuntu        Exited (0) ...             blissful_maxwell
37df1f1327a6   hello-world   Exited (0) ...             modest_antonelli
```

`docker images`는 이미지, `docker ps`는 현재 실행 중인 컨테이너, `docker ps -a`는 종료된 컨테이너도 포함한 목록을 보여준다.

### 7-3. hello-world 실행과 로그 확인

```bash
$ docker run --name hello-codyssey hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.

$ docker logs hello-codyssey
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

hello-world 컨테이너는 메시지 출력 후 종료되는 것이 정상이다.

### 7-4. 백그라운드 컨테이너 실행, 내부 명령, 리소스, 종료

```bash
$ docker run -dit --name ubuntu-ops ubuntu bash
9c8e90f6cc7388c370a684e5000f73cf3027e033395149611af93338fd5b6a9e

$ docker ps
CONTAINER ID   IMAGE    STATUS        NAMES
9c8e90f6cc73   ubuntu   Up 7 seconds  ubuntu-ops

$ docker exec ubuntu-ops bash -lc 'pwd; ls; echo "Hello from Ubuntu"'
/
bin
boot
# ... (다른 디렉터리 목록 생략)
usr
var
Hello from Ubuntu

$ docker stats --no-stream ubuntu-ops
CONTAINER ID   NAME         CPU %     MEM USAGE / LIMIT     MEM %
9c8e90f6cc73   ubuntu-ops   0.00%     9.926MiB / 3.752GiB   0.26%

$ docker stop ubuntu-ops
ubuntu-ops

$ docker ps -a
CONTAINER ID   IMAGE     STATUS                          NAMES
9c8e90f6cc73   ubuntu    Exited (137) ...               ubuntu-ops
```

**관찰:** `docker run -it ... bash`는 터미널에 직접 진입했고, `docker run -dit ...`는 백그라운드 실행 상태를 유지해 `docker exec`로 명령을 수행할 수 있었다.

종료 코드 137에 대한 추가 확인:

```bash
$ docker inspect --format 'ExitCode={{.State.ExitCode}} OOMKilled={{.State.OOMKilled}}' ubuntu-ops
ExitCode=137 OOMKilled=false
```

`137`은 강제 종료(SIGKILL)를 뜻한다. `OOMKilled=false`로 Docker가 OOM 종료로 기록하지 않았음을 확인했으나, **정확한 종료 원인은 확정하지 않았다.**

---

## 8. 커스텀 Dockerfile과 웹 서버

### 8-1. 프로젝트 파일 구조 및 Dockerfile

이번 미션의 **Dockerfile은 프로젝트 루트에 직접 작성**했다.

```text
codyssey_project/
├── README.md
├── Dockerfile
├── site/
│   └── index.html
├── practice.txt
└── practice/
    └── terminal/
        └── hello.txt
```


**Dockerfile (실습한 설정을 재현할 수 있는 형태)**

```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey_project"
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```

- `FROM`: NGINX Alpine 이미지를 기반으로 선택한다.
- `LABEL`: 이미지 식별 정보를 추가한다.
- `COPY`: 호스트의 `site/` 웹페이지를 NGINX 기본 문서 폴더로 복사한다.
- `EXPOSE`: 컨테이너 내부에서 사용하는 80번 포트를 문서화한다.


### 8-2. 이미지 빌드와 결과

**최초 실패:**

```bash
$ docker build -t codyssey-project:1.0
ERROR: docker: 'docker buildx build' requires 1 argument
```

원인은 명령어 끝에 빌드 컨텍스트(`.`)를 빠뜨린 것이다.

**수정 후 성공:**

```bash
$ docker build -t codyssey-project:1.0 .
[+] Building 13.1s (8/8) FINISHED
 => [1/2] FROM docker.io/library/nginx:alpine@sha256:...
 => [2/2] COPY site/ /usr/share/nginx/html/
 => naming to docker.io/library/codyssey-project:1.0
 => unpacking to docker.io/library/codyssey-project:1.0

$ docker images
IMAGE                  ID             DISK USAGE
codyssey-project:1.0   37b349e1ec36       93.6MB
hello-world:latest     c567b231f656       25.9kB
ubuntu:latest          6a06111c3b0a        163MB
```

### 8-3. 컨테이너 실행과 포트 매핑

```bash
$ docker run -d -p 8080:80 --name codyssey-server codyssey-project:1.0
cd3180d932bf6e0dc2dd943ba106f6235d69053667543ea6f52ef09b81f39f9a

$ docker ps
CONTAINER ID   IMAGE                  STATUS          PORTS                                   NAMES
cd3180d932bf   codyssey-project:1.0   Up 13 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp codyssey-server
```

- **호스트 포트 `8080` → 컨테이너 포트 `80`**으로 매핑했다.

**보안 참고:** 첫 실습은 `-p 8080:80`으로 외부 인터페이스에도 바인딩되었다. 로컬 실습만 필요하다면 재실행 시 `-p 127.0.0.1:8080:80`으로 접속 범위를 제한할 수 있다(기존 컨테이너를 그대로 두고 포트 설정만 바꿀 수는 없음).

---

## 9. 바인드 마운트: 호스트 파일 수정 반영

### 9-1. 실행 및 마운트 정보 검증

```bash
$ MSYS_NO_PATHCONV=1 docker run -d --name codyssey-bind -p 127.0.0.1:8081:80 --mount "type=bind,source=C:/codyssey-week1/codyssey_project/site,target=/usr/share/nginx/html,readonly" codyssey-project:1.0
d3784cc8eb003e164656f922611809c3f7f534775599069c05b29f16d601d501

$ docker ps
CONTAINER ID   IMAGE                  STATUS          PORTS                    NAMES
d3784cc8eb00   codyssey-project:1.0   Up 10 seconds   127.0.0.1:8081->80/tcp   codyssey-bind

$ docker inspect --format '{{json .Mounts}}' codyssey-bind
[{"Type":"bind","Source":"C:/codyssey-week1/codyssey_project/site","Destination":"/usr/share/nginx/html","Mode":"","RW":false,"Propagation":"rprivate"}]
```

- `type=bind`: 호스트 폴더를 컨테이너 문서 폴더와 연결한다.
- `readonly`: 컨테이너 내부에서는 연결된 폴더를 수정할 수 없도록 한다 (`RW:false`).
- `MSYS_NO_PATHCONV=1`: MSYS2 Git Bash가 Linux 경로를 Windows Git 설치 경로로 바꾸지 않도록 한다.

### 9-2. 변경 전후 비교

1. `http://localhost:8081`을 열어 **변경 전** 내용을 확인한다.
2. VS Code에서 호스트의 `site/index.html` 내용을 수정하고 저장한다.
3. `docker build`나 `docker run`을 다시 하지 않고 브라우저를 새로고침한다.

**검증 결론:** Docker 이미지 자체를 다시 생성하지 않아도, 바인드 마운트된 호스트 파일의 변경사항이 웹 서버 응답에 반영되었다.

---

## 10. Docker 볼륨: 컨테이너 삭제 후 데이터 유지

### 10-1. 볼륨 생성과 첫 번째 컨테이너

```bash
$ docker volume create codyssey-data
codyssey-data

$ docker volume ls
DRIVER    VOLUME NAME
local     codyssey-data

$ MSYS_NO_PATHCONV=1 docker run -d --name codyssey-vol1 --mount type=volume,source=codyssey-data,target=/data ubuntu sleep infinity
8bbf829978b398d6531900bbf14d79d5ab47e3536de8f1f8e7f2ecb36bb87b39
```

### 10-2. 파일 작성 및 내용 확인

```bash
$ docker exec codyssey-vol1 sh -c 'echo "Codyssey Volume Test" > /data/hello.txt'

$ docker exec codyssey-vol1 cat /data/hello.txt
cat: 'C:/Program Files/Git/data/hello.txt': No such file or directory

$ MSYS_NO_PATHCONV=1 docker exec codyssey-vol1 cat /data/hello.txt
Codyssey Volume Test
```

첫 번째 `cat`은 Windows Git Bash의 경로 자동 변환으로 실패했다. `MSYS_NO_PATHCONV=1`을 지정한 뒤 볼륨의 실제 데이터가 출력되었다.

### 10-3. 컨테이너 삭제 및 두 번째 컨테이너 재연결

```bash
$ docker rm -f codyssey-vol1
codyssey-vol1

$ docker volume ls
DRIVER    VOLUME NAME
local     codyssey-data

$ MSYS_NO_PATHCONV=1 docker run -d --name codyssey-vol2 --mount type=volume,source=codyssey-data,target=/data ubuntu sleep infinity
879fdf87bb75055f1bfff2152e7b7c53c4f34bb201a8afdb69faf02e1f01998f

$ MSYS_NO_PATHCONV=1 docker exec codyssey-vol2 cat /data/hello.txt
Codyssey Volume Test
```

**검증 결론:** `codyssey-vol1`을 삭제했지만 `codyssey-data` 볼륨은 남았고, `codyssey-vol2`에서도 동일한 `hello.txt` 내용을 읽을 수 있었다. **Docker 볼륨의 데이터 영속성 실습 완료.**

**바인드 마운트와 볼륨의 차이**

| 구분 | 바인드 마운트 | Docker 볼륨 |
|---|---|---|
| 연결 대상 | 호스트의 명시적인 폴더(`site/`) | Docker가 관리하는 이름 있는 볼륨(`codyssey-data`) |
| 이번 목적 | HTML 수정사항 즉시 반영 | 컨테이너 교체 후 데이터 유지 |
| 주요 증거 | `Type=bind`, `RW=false`, 화면 변경 전후 | 첫 컨테이너 삭제 후 동일 텍스트 재출력 |

---

## 11. 트러블슈팅 (실제로 발생한 문제)

| 사례 | 문제 / 관찰 | 원인 확인 및 해결 | 검증 |
|---|---|---|---|
| 1. Git 등록 실패 | `git add practice/` → `pathspec ... did not match any files` | 당시 `practice/`가 없었음. `mkdir -p practice/terminal` 및 실습 파일 생성 후 재시도 | `git status`에서 새 파일 확인, 커밋·푸시 성공 |
| 2. 파일 이동 명령 | `mv backup/practice.txt` → `missing destination file operand` | 이동 대상 `.` 누락. `mv backup/practice.txt .` 실행 | 루트의 `practice.txt` 확인 후 빈 폴더 삭제 |
| 3. Git 커밋 메시지 | `git commit` → `Aborting commit due to empty commit message` | 메시지 없이 편집기 종료. `git commit -m "Update README"`로 재실행 | 커밋 `3a1d23c` 성공 |
| 4. 경로·철자 실수 | `cd codyssey-project`와 실제 `codyssey_project` 혼동, `cd cd ...`, `cd/practice` | 현재 경로와 정확한 폴더명, 공백 확인 | 올바른 `cd /c/codyssey-week1/codyssey_project` 실행 |
| 5. Docker 이미지 빌드 | `docker build -t codyssey-project:1.0` → `requires 1 argument` | 빌드 컨텍스트 `.` 누락. 끝에 `.` 추가 | `(8/8) FINISHED`, 이미지 목록 표시 |
| 6. 바인드 마운트 옵션 | `type=bind, source=...`, `readnoly` | 쉼표 뒤 공백과 철자 오류. `type=bind,source=...,readonly`로 수정 | `docker inspect`: `Type=bind`, `RW=false` |
| 7. MSYS 경로 변환 | `docker exec ... cat /data/hello.txt` → Git 설치 경로로 변환 | Git Bash에서 Linux 경로 자동 변환. `MSYS_NO_PATHCONV=1` 사용 | `Codyssey Volume Test` 정상 출력 |
| 8. Docker 종료 코드 | `ubuntu-ops` → `Exited (137)` | 추가 검사에서 `OOMKilled=false`; 종료 신호 처리 가능성 있으나 원인 미확정 | `docker inspect`로 OOM 여부 확인 |

**그 밖의 관찰**

- `git add` 뒤에 파일/경로를 지정하지 않으면 `Nothing specified, nothing added`가 출력된다.
- 터미널의 `$` 프롬프트를 명령어에 포함하면 `bash: $: command not found` 오류가 발생한다.
- 작은따옴표를 닫지 않으면 Bash가 `>` 보조 프롬프트로 계속 입력을 기다린다. `Ctrl+C`로 취소할 수 있다.
- 파일명 오타(`permissio.txt`, `prctice.txt`)가 있으면 해당 파일을 찾을 수 없다.
- `LF will be replaced by CRLF`는 Windows 환경의 줄바꿈 방식 관련 경고이며, 실제 파일 등록과 푸시는 성공했다.

## 12. 실습 결과물·증거 연결 위치

| 자료 | 제출 위치 / 조치 | 상태 |
|---|---|---|
| 프로젝트 설명 및 명령어·결과 | 이 `README.md` | 작성 |
| 커스텀 이미지 설정 | [`Dockerfile`](Dockerfile) | 로컬에서 작성·빌드 확인, GitHub 최종 업로드 확인 필요 |
| 웹사이트 소스 | [`site/index.html`](site/index.html) | 로컬에서 실행·수정 확인, GitHub 최종 업로드 확인 필요 |
| 터미널 실습 파일 | [`practice/terminal/hello.txt`](practice/terminal/hello.txt) | 커밋 `418fa8d`에서 업로드 확인 |
| GitHub 로그인·VS Code 연동 | `1.git-hub연동.png` |
| Docker 빌드 성공 화면 | `2.docker실행결과.png` |
| 포트 매핑 접속 화면 | `3.dockerfile(8080).png` |
| 바인드 변경 전/후 | `4.dockerfile(8081).png`, `5.dockerfile(mount).png` |
| 파일·폴더 권한 전후 | `screenshots/permissions.png` |
| Docker 볼륨 검증 | 위 10절의 실제 명령/출력 | README에 기록, 별도 캡처 권장 |

## 13. 동일 환경에서 다시 실행하는 방법

### 13-1. 프로젝트 준비 및 이미지 빌드

```bash
git clone https://github.com/skypark-kr/codyssey_project.git
cd codyssey_project
# Dockerfile과 site/index.html이 저장소에 포함되어 있어야 함
docker build -t codyssey-project:1.0 .
```

### 13-2. 웹 서버 8080 실행

```bash
docker run -d --name codyssey-server -p 127.0.0.1:8080:80 codyssey-project:1.0
# 브라우저에서 http://localhost:8080 확인
curl -i http://localhost:8080
```

### 13-3. 바인드 마운트 8081 실행 (Git Bash / Windows)

재현하는 컴퓨터의 저장소 실제 경로로 `source=`를 수정해야 한다.

```bash
MSYS_NO_PATHCONV=1 docker run -d --name codyssey-bind -p 127.0.0.1:8081:80 --mount "type=bind,source=C:/codyssey-week1/codyssey_project/site,target=/usr/share/nginx/html,readonly" codyssey-project:1.0
# site/index.html 수정 후 http://localhost:8081 새로고침
```

### 13-4. Docker 볼륨 재현

```bash
docker volume create codyssey-data
MSYS_NO_PATHCONV=1 docker run -d --name codyssey-vol1 --mount type=volume,source=codyssey-data,target=/data ubuntu sleep infinity
docker exec codyssey-vol1 sh -c 'echo "Codyssey Volume Test" > /data/hello.txt'
MSYS_NO_PATHCONV=1 docker exec codyssey-vol1 cat /data/hello.txt
docker rm -f codyssey-vol1
MSYS_NO_PATHCONV=1 docker run -d --name codyssey-vol2 --mount type=volume,source=codyssey-data,target=/data ubuntu sleep infinity
MSYS_NO_PATHCONV=1 docker exec codyssey-vol2 cat /data/hello.txt
# 양쪽에서 Codyssey Volume Test가 출력되면 성공
```
