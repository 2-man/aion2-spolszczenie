# Dodatkowa fala QA — 14.10.2026

Przeprowadzono kolejną redakcję polskich szkiców. Zmieniano tylko pole `translation`; statusy pozostają `draft`, bo kontrola redakcyjna nie zastępuje testu tekstu w uruchomionej grze. Pliki audio pozostały nietknięte.

## Zakres i korekty

- `AchievementString`: 15 126 rekordów, 93 poprawki gramatyczne i terminologiczne, m.in. odmiana policzalnych lochów, forma „3 skrzydła”, pisownia nazwy „Shugo” i biernik „Zjawę Zikela”.
- `EnvObjData` i `GuideData`: 7 218 rekordów, 27 korekt nazw i opisów obiektów oraz poradników.
- `Title`, `TitleCategory`, `Skin`, `SkinSet`, `SkinPattern`, `SkinMaterial`, `Wing`, `ServerName`: 7 895 rekordów; ujednolicono jeden opis wyglądu.
- `String_str`: ponownie sprawdzono wszystkie 40 476 wpisów. W drugiej redakcji shardów 0001–0162 poprawiono 120 tekstów, a audyt terminu Pet/Pets dodał cztery poprawki systemowych wierzchowców i instrukcji wyścigu. Łącznie 124 korekty; zachowano ogólne znaczenie „zwierzak” w opisach Lugi i kalamburach „Pet Rock”.
- `locres-NCUMG`: 1 697 etykiet i podpowiedzi UI; 9 korekt znaczenia i terminologii, m.in. `Mouse Enter` → „Najechanie kursorem myszy”.
- Audyt terminologiczny Pet/Pets poza `String_str`: przeszukano 373 wystąpienia źródłowe w głównych tabelach i startupie; poprawiono dwa pewne użycia do „wierzchowiec/wierzchowce”, osiem pozostawiono jako ogólne zwierzaki. W zakresie audytu nie znaleziono „Ochraniacza”.

Łącznie z raportów falowych wynika **256 zmienionych rekordów** w tej serii przeglądów (93 + 27 + 1 + 124 + 9 + 2). Główne raporty szczegółowe: `achievementstring-qa-2026-10-14-wave2.md`, `envobj-guidedata-qa-2026-10-14.md`, `items-titles-skin-qa-2026-10-14.md`, `string-str-early-shards-qa-2026-10-14.md`, `string-str-middle-qa-2026-10-14.md`, `string-str-late-qa-2026-10-14.md`, `pet-terminology-stringstr-2026-10-14.md`, `pet-terminology-consistency-2026-10-14.md` oraz `ncumg-ui-second-pass-2026-10-14.md`.

## Walidacja i otwarte prace

Walidacja tabel głównych zakończyła się poprawnie dla 164 858 rekordów (`errors: []`). Walidacja sidecara koreańsko-polskiego: 9 569 rekordów, 98 partii, bez błędów. Walidacja supplemental: 8 rekordów, bez błędów. Testy projektu: **52 zaliczone**. Nowy DAT ma SHA-256 `f863cad3d41e85a979de33d2766ff7cfc613c99613283dec2fd541eb4b5e7974`; semantyczny round-trip 153 042 rekordów przeszedł. Podglądowy ZIP przechodzi CRC i ma SHA-256 `02e4cbb10d979bab6bf2bb39d8c519935eff661d4c9aebb383ebc4bfd66715b5`.

W tabelach głównych i Engine wciąż widnieje 9 609 statusów `pending`. Nakładki dostarczają tłumaczenie dla 9 570 wpisów: 9 567 dokładnych dopasowań sidecara oraz trzy zadania ze źródłem `TBD`. Pozostałe 39 pozycji mają nieodzyskane źródła: 10 aliasów `String_str`, 2 pola `String_ui` zawierające wyłącznie `???` oraz 27 wartości LOCRES Engine będących `####`. Nie dodawano zgadywanych przekładów.

Nowy DAT zainstalowano w kliencie w slocie `en-US`; nie uruchamiano jeszcze gry z tą wersją, więc kontrola tekstów w runtime pozostaje otwarta. Pełna integracja SDK/startup/pozostałych LOCRES i ich test w kliencie również pozostają otwarte.
