# Redash 구축

### Redash 사양
- CPU(Core): 1개 이상
- Memory: 4 GB 이상

### env 설정
#### [environment 상세 문서](https://redash.io/help/open-source/admin-guide/env-vars-settings)
```
PYTHONUNBUFFERED=0

REDASH_LOG_LEVEL=INFO
REDASH_REDIS_URL=redis://redis:6379/0

POSTGRES_PASSWORD=test
REDASH_DATABASE_URL=postgresql://postgres:test@postgres_12/redash

REDASH_COOKIE_SECRET=vV87HYI7Q4r8JXZS9ixHQrWWmx52pIEG
REDASH_SECRET_KEY=BTHPVt5jNzwSLAle2FCDTs32XEjfXLRk

REDASH_MAIL_SERVER=localhost
REDASH_MAIL_PORT=25
REDASH_MAIL_USE_TLS=false
REDASH_MAIL_USE_SSL=false
REDASH_MAIL_USERNAME=None
REDASH_MAIL_PASSWORD=None
REDASH_MAIL_DEFAULT_SENDER=hanyoon_test@test.com

# aws athena 설정 
ATHENA_ANNOTATE_QUERY=false

# 구글 로그인 연동 시
REDASH_GOOGLE_CLIENT_ID  
REDASH_GOOGLE_CLIENT_SECRET
```
### redash 실행
```
docker-compose up -d
```
