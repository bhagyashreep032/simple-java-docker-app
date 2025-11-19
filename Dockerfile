FROM openjdk:17-jdk
WORKDIR /app

COPY src/Hello.java .

RUN javac Hello.java

CMD ["java", "Hello"]
