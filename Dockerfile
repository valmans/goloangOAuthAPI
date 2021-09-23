FROM registry.semaphoreci.com/golang:1.15 as builder
 ENV APP_USER app
 ENV APP_HOME /src/goloangOAuthAPI
 RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
 RUN mkdir -p $APP_HOME && chown -R $APP_USER:$APP_USER $APP_HOME
 WORKDIR $APP_HOME
 USER $APP_USER
 COPY src/ .
 RUN go mod download
 RUN go mod verify
 RUN go build -o mathapp
 FROM debian:buster
 FROM registry.semaphoreci.com/golang:1.15
 ENV APP_USER app
 ENV APP_HOME /go/src/mathapp
 RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
 RUN mkdir -p $APP_HOME
 WORKDIR $APP_HOME
 COPY src/conf/ conf/
 COPY src/views/ views/
 COPY --chown=0:0 --from=builder $APP_HOME/mathapp $APP_HOME
 EXPOSE 8010
 USER $APP_USER
 CMD ["./goloangOAuthAPI"]