# AION2 PL — wydanie GitHub

W katalogu głównym są dwa foldery: `01-Zrodla-tlumaczenia` zawiera rozpakowane tłumaczenia do edycji oraz raporty wydania i fal QA, a `02-Paczka-do-gry` zawiera gotowy plik DAT, instalator i narzędzie do aktualizacji lub przywrócenia oryginałów.

## Instalacja

1. Pobierz repozytorium przez **Code → Download ZIP** i rozpakuj je.
2. Zamknij grę. Skopiuj zawartość folderu `02-Paczka-do-gry` do głównego folderu gry, obok `Aion2` i `Engine`, zezwalając na nadpisanie plików.
3. Uruchom `install.cmd` bezpośrednio z głównego folderu gry. Skrypt przekazuje ścieżkę zakończoną `\.` — to zabezpiecza ścieżki ze spacjami przed błędnym parsowaniem cudzysłowu przez cmd.exe. Nie otwiera okna wyboru folderu.
4. Uruchom grę z ustawionym językiem English. Tłumaczenie korzysta ze slotu `en-US`.

Instalator nie porównuje wersji klienta z hashami archiwów paczki i obsługuje także niepełny zestaw PAK/SIG/UCAS/UTOC. Zapisuje kopię dostępnych plików językowych i poprzedniego DAT w `AION2-PL-LOOSE/history`, a sumami SHA-256 sprawdza kopie i nowy DAT. `AKTUALIZUJ.cmd` wgrywa paczkę po aktualizacji gry. Do cofnięcia zmian uruchom `AION2-PL-LOOSE/PRZYWROC-ANGIELSKI.cmd`.

`INSTALUJ.cmd` i `install.cmd` są równoważne; `AKTUALIZUJ.cmd` i `update.cmd` również. Wypakuj pliki paczki do głównego folderu gry i uruchom odpowiedni skrypt tam. Jeśli Steam odtworzył archiwa po aktualizacji, instalator zapisze je jako nowy punkt przywracania.

## Rozpakowanie i edycja źródeł

Po rozpakowaniu ZIP folder `01-Zrodla-tlumaczenia` zawiera czytelne pliki UTF-8 JSONL, posegregowane według tabel. Każda linia jest jednym wpisem. Edytuj pole `translation`; zachowuj `id`, `source`, placeholdery, tagi, znaczniki i sekwencje nowych linii. `draft` oznacza szkic, `reviewed` wpis po redakcji, a `pending` brak tłumaczenia.

## Ponowne zbudowanie wydania

W pełnym katalogu projektu skopiuj zmienione pliki z folderu źródeł do `translations/`, a następnie uruchom z katalogu projektu:

```powershell
python scripts/validate_translations.py
python scripts/validate_crosslocale_translations.py
python scripts/validate_crosslocale_supplemental.py
python -m pytest -q tests
python scripts/build_loose_test4.py
python scripts/package_loose.py
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Prepare-Github-Release.ps1
Compress-Archive -Path .\github-release\* -DestinationPath .\AION2-PL-GitHub.zip -Force
```

Powstały `github-release` zawiera oba foldery do publikacji. ZIP można rozpakować poleceniem:

```powershell
Expand-Archive .\AION2-PL-GitHub.zip -DestinationPath .\AION2-PL-GitHub -Force
```

## Osobny język polski

W badanym kliencie nie znaleźliśmy rejestracji kultury `pl-PL` w menu ani kompletnego zestawu jej zasobów. Sam folder `pl-PL` nie dodaje języka do wyboru. Wydanie używa sprawdzonego slotu English; interfejs menu nadal pokazuje English.

## Dodatkowe zasoby testowe

`02-Paczka-do-gry/DODATKI-TESTOWE/AION2-PL-extras-test.zip` zawiera osobny, eksperymentalny zestaw SDK/startup/LOCRES. Główny instalator go nie instaluje. Dodatek jest niepodpisany; jego załadowanie przez klienta nie zostało potwierdzone. Instrukcja i raport są obok archiwum. Dodatek ma własny menedżer instalacji i przywracania; nie zastępuje głównej paczki.

## Zakres

Wydanie główne zawiera tabelę główną i nakładki tekstów. SDK, startup i LOCRES mają osobny pakiet eksperymentalny w `DODATKI-TESTOWE`; runtime tych zasobów pozostaje niepotwierdzony. Nie wszystkie tłumaczenia są zredagowane ani sprawdzone w grze; raport pokrycia znajduje się w `01-Zrodla-tlumaczenia`. Audio pozostaje oryginalne. Paczka jest przypisana do wersji klienta wskazanej w `release-manifest.json`.