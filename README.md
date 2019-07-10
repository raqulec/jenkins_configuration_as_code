### Jenkins prezentacja -- tworzenie jobów i pipeline Część 1.

Co potrzebujemy:
1) Zainstalowany Jenkins -- https://jenkins.io/
2) Konto na Github -- <https://github.com/> (zainstalowany Git Bash)
3) Konto na Heroku -- <https://www.heroku.com/> (zainstalowany Heroku CLI, wygenerowany klucz SSH)

Zadania do wykonania dla Jenkinsa:

1) Wrzuć projekt z Github na serwer Heroku
2) Poczekaj 5 sekund.
3) Sprawdź status serwera (200 - OK) -- <https://pl.wikipedia.org/wiki/Kod_odpowiedzi_HTTP>

**KROK 1.** Tworzenie Joba -- Wrzuć projekt z Github na serwer Heroku

a) Nowy Projekt > Ogólny Projekt
b) Konfigurujemy sektor „Repozytorium kodu" wskazujemy dwa nasze repozytoria Githuba i Heroku, dodajemy użytkownika i hasło (dla heroku kilkamy jeszcze zaawansowane i dajemy nazwe „heroku")
c) Konfigurujemy sektor „Akcje po zadaniu", wybieramy Git Publisher i wybieramy:

- Ustawiamy branches na „Branchu to push": master, „Target remote name": heroku

**KROK 2.** Tworzenie Joba -- Poczekaj 5 sekund

a) Nowy Projekt > Ogólny Projekt
b) Konfigurujemy sektor „General" wybieramy „Cichy okres" ustawiamy na 5 sekund
c) Konfigurujemy sektor „Wyzwalacze zadania" zaznaczamy „Uruchamiaj gdy inne zadanie zostaną zakończone" Obserwowane projekty HerokuDepoly, zaznaczamy uruchamiaj tylko, jeśli zadanie było stabilne

**KROK 3.** Tworzenie Joba ­-- Sprawdź status serwera (200 - OK)

a) Instalujemy pierwszy plugin! Zarządzaj Jenkinsem > Zarządzaj wtyczkami > Dostępne wpisujemy „http Request" klikamy „Zainstaluj bez ponownego uruchamiania"
b) Nowy Projekt > Ogólny Projekt
c) Konfigurujemy sektor „Budowanie" wybieramy „http Request" http mode „GET".
d) Konfigurujemy sektor „Wyzwalacze zadania" zaznaczamy „Uruchamiaj gdy inne zadanie zostaną zakończone" Obserwowane projekty Delay, zaznaczamy uruchamiaj tylko, jeśli zadanie było stabilne

**KROK 4.** Łączymy nasze Joby w pipeline

a) Instalujemy plugin. Zarządzaj Jenkinsem > Zarządzaj wtyczkami > Dostępne wpisujemy „Delivery Pipeline" klikamy „Zainstaluj bez ponownego uruchamiania"
b) Przechodzimy do ekranu głównego, klikamy „plusik", wybieramy „Delivery Pipeline View", nadajemy nazwę widoku np. „BuildPipeline"
c) Po przejściu do konfiguracji widoku przechodzimy do sekcji „Pipelines", nadajemy nazwę komponentu „BuildPipeline", ustawiamy Initial Job na „HerokuDeploy"

### Jenkins prezentacja -- tworzenie skryptów DSL (*domain-specific language*) Część 2.

**KROK 1.** Instalujemy plugin Job DSL.

a) Zarządzaj Jenkinsem > Zarządzaj wtyczkami > Dostępne wpisujemy „Job DSL" klikamy „Zainstaluj bez ponownego uruchamiania"

**KROK 2.** Tworzymy DSL skrypt dla joba HerokuDepoly

a) Odpalamy edytor kodu np. Visual Studio Code, tworzymy plik w formacie groovy
b) Wchodzimy na dokumentacje dla „Job DSL" URL: `/plugin/job-dsl/api-viewer/index.html`
c) Klikamy na przycisk widoczny w lewym górnym rogu ekranu (po prawej stronie ekranu pokaże się lista pluginów) i wybieramy plugin GIT, wybieramy DSL Methods git: git: „ScmContext"

**OPIS**: na stronie widzimy podane przykłady, posiłkowałem się przykładem drugim, na dole strony mamy podane obszary z których dany plugin korzysta.

d) Modyfikujemy „przykład drugi" uzupełniając dane do naszych repozytoriów Github i Heroku, dodajemy do naszego repozytorium Github, Heroku id naszych uprawnień. Określamy również gałąź, z której będziemy sprawdzać zmiany.
e) Pozostając przy modyfikacji, cofamy się na stronie z dokumentacją do poprzedniej strony i wybieramy git: PublisherContext, określamy gałąź wskazując na heroku
f) Zapisujemy plik. (Wrzucamy plik do nowo utworzonego repozytorium na Githubie).

**KROK 3.** Tworzymy DSL skrypt dla joba Delay

a) Odpalamy edytor kodu np. Visual Studio Code, tworzymy plik w formacie groovy
b) Wchodzimy na dokumentacje dla „Job DSL" URL: `/plugin/job-dsl/api-viewer/index.html`
c) Klikamy po lewej stronie ekranu freeStyleJob, rozwijamy listę metod klikając na „trzy kropki". Wybieramy quietPeriod().
d) Dodajemy triggers z metodą upstream wskazujemy HerokuDepoly i wpisujemy SUCCESS.
e) Zapisujemy plik. (Wrzucamy plik do nowo utworzonego repozytorium na Githubie).

**KROK 4.** Tworzymy DSL skrypt dla joba CheckServerStatus

a) Odpalamy edytor kodu np. Visual Studio Code, tworzymy plik w formacie groovy
b) Wchodzimy na dokumentacje dla „Job DSL" URL: `/plugin/job-dsl/api-viewer/index.html`
c) Klikamy na przycisk widoczny w lewym górnym rogu ekranu (po prawej stronie ekranu pokaże się lista pluginów) i wybieramy plugin HTTP Request, wybieramy DSL Methods httpRequest : StepContext. Posiłkując się przykładem wybieramy httpRequest i wpisujemy adres naszej strony Heroku, wybieramy httpMode i ustawiamy na GET
d)  Dodajemy triggers z metodą upstream wskazujemy Delay i wpisujemy 'SUCCESS'.
e) Zapisujemy plik. (Wrzucamy plik do nowo utworzonego repozytorium na Githubie).

**KROK 5.** Instalujemy i konfigurujemy plugin Job DSL.

a) Zarządzaj Jenkinsem > Zarządzaj wtyczkami > Dostępne wpisujemy „Seed Jenkins" klikamy „Zainstaluj bez ponownego uruchamiania"
b) Nowy Projekt > Ogólny Projekt
c) Konfigurujemy sektor „Budowanie" wybieramy „Process Job DSLs" w sekcji DSL Scripts wpisujemy '**/*.groovy'
d) Konfigurujemy sektor „Repozytorium kodu" wskazujemy repozytorium Githuba (te w którym umieściliśmy wszystkie nasze joby w postaci skryptów DSL), wskazujemy uprawnienia.
e) Przechodzimy do ekranu głównego, Zarządzaj Jenkinsem > Konfiguruj ustawienia bezpieczeństwa, przechodzimy do sekcji CSRF Protection i odznaczamy Enable script security for Job DSL scripts.

**OPIS**: po odpaleniu joba SeedJob, Jenkins będzie automatycznie zakładał nam joby z pieplinem.

### Jenkins prezentacja -- konfiguracja Jenkinsa od strony kodu (*Jenkins Configuration as Code plugin*) Część 3.

Co potrzebujemy:

1) Utworzone konto na docker.com ­-- https://www.docker.com/ (zainstalowany Docker Desktop for Windows, lub Docker Toolbox w zależności od wersji Windowsa).

**OPIS**: Gdy używamy Hyper-V należy go ubić, bo VirtualBox go nie lubi.

a) bcdedit /set hypervisorlaunchtype off by wyłączyć Hyper-V. Pamiętać o zrestartowaniu  komputera.
b) bcdedit /set hypervisorlaunchtype auto by włączyć ponownie Hyper-V. Pamiętać o zrestartowaniu komputera.

**KROK 1**. Instalujemy i konfigurujemy plugin "Startup Trigger".

a) Zarządzaj Jenkinsem > Zarządzaj wtyczkami > Dostępne wpisujemy „Startup Trigger" zaznaczamy plugin "Startup Trigger" następnie klikamy „Zainstaluj bez ponownego uruchamiania".
b) Nowy Projekt > Ogólny Projekt. Zapisujemy Joba.

**KROK 2.** Dodajemy zależność między jobem „SeedJob" a „StartupTrigger"

a) Wchodzimy ponownie do konfiguracji joba „SeedJob" i przechodzimy do sekcji „Wyzwalacze zadania", zaznaczamy „Uruchamiaj, gdy inne zadania zostaną zakończone", w obserwowanych projektach wpisujemy „StartupTrigger".

**OPIS**: dzięki temu zabiegowi, przy następnym odpaleniu Jenkinsa automatycznie pobiorą się lub nadpiszą nasze wcześniej utworzone na GitHubie joby.

**KROK 3.** Przygotowanie listy pluginów

a) Zarządzaj Jenkinsem > Konsola skryptów. Wykonujemy poniższy skrypt:
```
Jenkins.instance.pluginManager.plugins.each{

 plugin ->

 println ("${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}")

}
```
**OPIS**: Wybieramy tylko te pluginy które nas interesują w naszym przypadku będą to:

- git:latest
- http_request:latest
- job-dsl:latest
- startup-trigger-plugin:latest
- configuration-as-code:latest
- configuration-as-code-support:latest
- seed:latest
- workflow-aggregator:latest

Liste pluginów zapisujemy do pliku (plugins.txt). (**Utworzyć folder gdzie będziemy trzymać pliki!**)

**KROK 4.** Instalujemy i konfigurujemy plugin "Configuration as Code" oraz "Configuration as Code Support".

a) Zarządzaj Jenkinsem > Zarządzaj wtyczkami > Dostępne wpisujemy „configuration as code" zaznaczamy plugin "Configuration as Code" oraz "Configuration as Code Support" następnie klikamy „Zainstaluj bez ponownego uruchamiania".
b) Zarządzaj Jenkinsem > Configuration as Code > klikamy Download Configuration (plik będziemy modyfikować w kolejnym kroku)

**KROK 5.** Przygotowanie pliku konfiguracyjnego.

a) Edytujemy wcześniej utworzony plik, zostawiamy rzeczy które nas interesują czyli: Credentials, konfiguracja gita, wyłączenie „useSriptSecurity".
b) Do pliku konfiguracyjnego dopisujemy dwa joby (należy pamiętać że sekcje rozpoczynamy od „jobs:" każdego nowego joba zaczynamy od „- script: >":

- SeedJob ­-- dopisujemy sekcje dla naszego repozytorium oraz sekcje dla pluginu Seed gdzie wpisujemy skąd ma pobierać pliki. Dopisujemy również sekcje triggers z metodą upstream wskazujemy „StartUpTrigger" i wpisujemy 'SUCCESS'.

`- `StartUpTrigger wpisujemy wszystkie metody podane w dokumentacji jako puste stringi (UWAGA: gdy ich nie podamy podczas instalacji Jenkinsa wywali błąd że wszystkie parametry są wymagane) URL: `/plugin/job-dsl/api-viewer/index.html.`

c) Gotowy plik zapisujemy pod nazwą „jenkins.yaml".

**KROK 6.** Przygotowanie pliku Dockerfile.

a) Poniższe komendy zapisujemy do pliku i nadajemy mu nazwę „Dockerfile".
```
FROM jenkins/jenkins:lts

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
```
**KROK 7.** Utworzenie obrazu i jego uruchomienie.

Za pomocą PowerShella przechodzimy do naszego katalogu i odpalamy poniższą komendę:
```
docker build -t nazwaObrazu.
```
Następnie uruchamiamy obraz za pomocą komendy:

```
docker run --name nazwaKontenera -d -p 8081:8080 nazwaObrazu
```

Po przejściu na stronę <http://localhost:8081>` (localhost dockera!) widzimy zainstalowanego Jenkinsa z pluginami i dodanymi jobami.`