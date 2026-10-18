# Przegląd i korekty tłumaczeń — fala 2026-10-14

Ta fala kontynuowała redakcję po podziale zakresów między agentów GPT-6 Luna. Prace dotyczyły wyłącznie tekstu; audio nie było zmieniane.

## Wykonane prace

- Sprawdzono 52 dostępne shardy koreańsko-polskiego sidecara dialogów NPC. W polach `translation` pojawiło się 25 korekt w kilku shardach; ID, source, source SHA, status `draft`, tagi i placeholdery pozostały zachowane.
- Skontrolowano wszystkie 1588 wpisów sidecara QuestString; poprawiono 2 niezręczne sformułowania.
- Skontrolowano 2859 wpisów sidecara SkillString i SkillAbnormalString; poprawiono 85 szkiców, ujednolicając rozróżnienie odporności i niewrażliwości na efekty.
- Skontrolowano 8 rekordów supplemental; poprawiono 1 wpis. Trzy rekordy z canonical source `TBD` nadal mają polskie wartości z koreańskiego sidecara.
- Przejrzano 127 nowych wpisów UI/String i poprawiono 41. Zweryfikowano również 110 wpisów Skin/SkinSet; nie znaleziono tam oczywistego błędu wymagającego zmiany.
- Porównano 12 zmienionych wpisów bieżącej wersji klienta z kanonicznymi wartościami. Zmieniono 6 kanonicznych tłumaczeń; kolejne 6 wariantów pozostawiono po ocenie bez zmian. Dodatkowo poprawiono eufonię w „we Wschodniej Dolinie”.
- Dwa nieprzetłumaczalne symbole `++` w Engine oznaczono jako `technical` z niezmienioną wartością. Pozostałe źródłowe markery `####` nie dostały zgadywanych tłumaczeń.

## Walidacja i paczka

Walidator tabel głównych, oba walidatory sidecarów i testy projektu przeszły: **52 testy zaliczone**. Zbudowany DAT przeszedł semantyczny round-trip dla 153 042 rekordów. SHA-256 DAT: `326541e40d8d3fb4993d37a32d81a5f07f8bb75e04f4d64ebeda9eb9f9569c6a`. ZIP podglądowy ma SHA-256 `61a0b6432412d7e86a8c3c970e548870b1d5170e0f3d43acd6e9077572a53769`; ZIP GitHub przechodzi kontrolę CRC.

Ta wersja nie została jeszcze sprawdzona w uruchomionej grze. Statusy redakcyjne pozostają `draft`; raport walidatora nie jest równoznaczny z pełną akceptacją językową.

## Znane braki źródłowe

- 10 wartości `String_str` zawiera aliasy bez odnalezionego tekstu docelowego w lokalnych kulturach.
- 2 etykiety `String_ui` nadal mają `???` we wszystkich dostępnych kulturach.
- 27 wpisów Engine mają wyłącznie źródło `####`.
- Nie potwierdzono runtime dla aktualnego DAT ani kompletnego wczytania SDK/startup/LOCRES w grze.

Zadanie pełnej lokalizacji pozostaje aktywne; następne prace powinny szukać wiarygodnych źródeł brakujących wartości i kontynuować QA pozostałych szkiców.
