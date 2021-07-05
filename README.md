<div align="center">
    <img src=".meta/header.png" alt="Sonr-App-Header"/>
  <br>
</div>

# Description
> Share anything to everyone and everything.

# Build
### SQL
Generate SQL Table fields by running this Command.
`flutter packages pub run build_runner build`

### Enviornment Keys
Wrap Enviornment Variables with this command.
`flutter pub get`
`flutter pub run environment_config:generate --ip_key=$ip_key --rapid_key=$rapid_key --hs_key=$hs_key  --hs_secret=$hs_secret --storj_key=$storj_key --storj_root_password=$storj_root_password --sentry_dsn=$sentry_dsn --hub_key=$hub_key --hub_secret=$hub_secret --map_key=$map_key --map_secret=$map_secret`

### Proto-Dart
Add Protocol Buffer Generation for Dart Types with this command.
`pub global activate protoc_plugin`
