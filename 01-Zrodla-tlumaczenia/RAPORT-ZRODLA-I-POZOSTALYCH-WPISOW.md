# Odświeżenie źródeł i przegląd pozostałych tekstów — 2026-10-14

## Wynik

Odświeżono ekstrakcję z zainstalowanego klienta. Odczytano 281 indeksów PAK i zapisano 25 wybranych zasobów lokalizacyjnych: tabelę główną en-US (153 042 rekordy), startup (486), SDK StringTable (424) oraz wszystkie 17 angielskich tabel LOCRES (10 906 rekordów). Zaktualizowano `reports/extracted-files.json`, `reports/localization-containers.csv` oraz fingerprinty manifestów źródłowych. Wszystkie źródłowe ID i teksty w katalogach tłumaczeń zostały sprawdzone przez ekstraktor.

Dwa pakiety zawierają startupowy `L10NString.dat` o różnych sumach zaszyfrowanych bajtów, lecz dekodują się do identycznych 486 par ID/wartość i identycznego SHA-256 payloadu. `scripts/extract_localization.py` porównuje teraz treść po dekodowaniu dla DAT-ów; nadal zgłasza błąd, jeśli zmienią się rekordy lub ich wartości. W `PackageList_4_desc_long` i `PackageList_6_desc_long` zsynchronizowano pole `source` z bieżącym en-US. Istniejące polskie przekłady zachowano, bo zmiany źródła nie zmieniają znaczenia.

## Zakres dalszych braków

Przegląd całej rozpoznanej inwentaryzacji nie znalazł dodatkowej tabeli tekstowej poza katalogami main, startup, SDK i LOCRES. Nie znaleziono też nowych bezpiecznych do dopisania przekładów. 39 znanych braków nadal nie ma odzyskanego tekstu: 10 aliasów `String_str`, 2 źródła `String_ui` równe `???` i 27 wartości LOCRES Engine równych `####`. Nie zgadywano ich treści.

## Walidacja

- `validate_translations.py`: 164 858 rekordów, `errors=[]`.
- `validate_crosslocale_translations.py`: 9 569 rekordów, poprawny fingerprint bieżącej tabeli głównej.
- `validate_crosslocale_supplemental.py`: 8 rekordów, poprawny fingerprint bieżącej tabeli głównej.
- `python -m pytest -q tests`: 52 passed.
- `build_loose_test4.py`: pełny round-trip semantyczny przechodzi; 153 042 rekordy.
- `build_startup_dat.py`: 486 rekordów, 477 zmienionych wartości, zaszyfrowany DAT przechodzi pełny round-trip; nie spakowano PAK.
- `build_sdk.py`: 424 rekordy, 418 zmienionych wartości, walidacja kontenera i pełny round-trip retoc przechodzą; nagłówek UASSET jest identyczny bajt w bajt.

SDK i startup mają lokalne artefakty budowania po weryfikacji, ale nie zostały dołączone do instalatora gry. Główny loose DAT nie wymagał ponownego pakowania, bo ta fala nie zmieniła jego widocznych tekstów. Test działania wszystkich zasobów w runtime nadal jest otwarty.
