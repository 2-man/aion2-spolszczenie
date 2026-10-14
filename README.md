# AION2 PL — wydanie GitHub

Repozytorium ma dwa gotowe foldery:

- `01-Zrodla-tlumaczenia` — edytowalne pliki JSONL (główne tłumaczenia oraz nakładki dla tekstów odzyskanych z innych języków), z instrukcją.
- `02-Paczka-do-gry` — DAT i instalator/aktualizator. Zamknij grę, uruchom `INSTALUJ.cmd` i wskaż katalog główny AION2. W grze pozostaw język English. `AKTUALIZUJ.cmd` służy do kolejnych wersji; kopie oryginałów i rollback są obsługiwane przez instalator.

## Rozpakowanie i pakowanie

Pobierz repozytorium przyciskiem **Code → Download ZIP**, następnie rozpakuj ZIP np. do Pobranych. Nie kopiuj samego folderu `payload` do klienta: instalator weryfikuje wersję czterech plików English, tworzy kopie i umieszcza DAT w prawidłowej lokalizacji.

Pliki źródłowe edytuj w `01-Zrodla-tlumaczenia` (UTF-8 JSONL; zmieniaj wyłącznie pole `translation`, zachowuj `id`, `source`, `status`, tokeny i nowe linie). Z lokalnego pełnego projektu, po skopiowaniu zmian do `translations/`, zbuduj ponownie paczkę:

```powershell
python scripts/validate_translations.py
python scripts/validate_crosslocale_translations.py
python scripts/validate_crosslocale_supplemental.py
python scripts/build_loose_test4.py
python scripts/package_loose.py
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Prepare-Github-Release.ps1
```

Folder `github-release` zostanie odtworzony z aktualnych źródeł i DAT. Aby spakować oba foldery do archiwum do publikacji, będąc katalog wyżej:

```powershell
Compress-Archive -Path .\github-release\* -DestinationPath .\AION2-PL-GitHub.zip -Force
```

Do rozpakowania wydania w PowerShell:

```powershell
Expand-Archive .\AION2-PL-GitHub.zip -DestinationPath .\AION2-PL-GitHub -Force
```

## Język polski w menu

Ten klient nie rejestruje obecnie kultury `pl-PL`: oficjalne paczki tekstowe obejmują osiem języków, a brakuje klucza DAT i rejestracji klienta dla polskiego. Dlatego wydanie korzysta ze sprawdzonego w grze slotu English. Utworzenie folderu `pl-PL` samo w sobie nie dodaje języka do menu.

## Zakres i testy

To wydanie obejmuje tabelę główną; część tekstów SDK, startup i osobnych zasobów LOCRES nadal wymaga dopracowania. Wpisy są szkicami, nie wszystkie zostały zredagowane ani sprawdzone w grze. Audio pozostaje oryginalne. Przed każdym wydaniem wymagane są trzy walidatory oraz `python -m pytest -q tests`. Suma DAT i ZIP jest zapisywana w `reports/preview-package.json` po budowaniu preview.