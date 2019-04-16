FROM scratch
EXPOSE 8080
ENTRYPOINT ["/jenkins-on-kubernetes"]
COPY ./bin/ /