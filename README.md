# meteo_uyari

Get live weather alerts and notifications from https://www.mgm.gov.tr

## Supported platforms

- Android
- Linux/Ubuntu (No notifications)

## Project diagram

```mermaid
stateDiagram-v2
  state "https://www.mgm.gov.tr/meteouyari" as mgm
  state "Supabase edge functions" as sfunc
    state "Supabase Postgres database" as sdb
  state "Firebase cloud messagging" as fcm
  state "Client" as client
  state isAlertSaved <<choice>>
  state forkAlertNew <<fork>>
  state forAlertIsNotOld <<fork>>
  state forkGetAlerts <<fork>>
    sfunc --> forkGetAlerts : Get Alerts periodictly
    forkGetAlerts --> mgm : Request active alerts
    forkGetAlerts --> sdb : Remove alerts which are not in active alerts
    sfunc --> mgm : Get Cities when asked
    forkGetAlerts --> isAlertSaved: Check active alerts with alerts in database
    isAlertSaved --> forkAlertNew : Alert is not exists in database
    forkAlertNew --> sdb: Add alert
    forkAlertNew --> fcm: Send notifications
    isAlertSaved --> forAlertIsNotOld : Alert was saved to database  
    forAlertIsNotOld --> [*]: Do nothing
    sdb --> sfunc : Periodictly trigger new alert checks from postgres extention
    fcm --> client: Weather alert notification
    client --> sdb: Get active alerts
    client --> sfunc: Get cities
```
