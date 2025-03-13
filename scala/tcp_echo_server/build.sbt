val scala3Version = "3.6.4"
val AkkaVersion = "2.10.2"

lazy val root = project
  .in(file("."))
  .settings(
    name := "tcp_echo_server",
    version := "0.1.0-SNAPSHOT",
    scalaVersion := scala3Version,
    resolvers += "Akka library repository".at("https://repo.akka.io/maven"),
    libraryDependencies ++= Seq(
      "org.scalameta" %% "munit" % "1.0.0" % Test,
      "com.typesafe.akka" %% "akka-actor-typed" % AkkaVersion
    )
  )
