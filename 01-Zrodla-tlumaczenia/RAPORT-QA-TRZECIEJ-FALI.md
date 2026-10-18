# Redakcja i audyt tłumaczeń — fala 3 (14.10.2026)

W tej fali wykonano dodatkową redakcję i sprawdzenie przekładów, korzystając głównie z agentów GPT-6 Luna. Poprawki redakcyjne zmieniały wyłącznie pole `translation`; statusy pozostawiono jako `draft`, bo kontrola językowa nie zastępuje testu w grze. Wyjątkiem technicznym było przywrócenie końców CRLF zgodnych z wydanymi źródłami w kilku JSONL. Audio pozostało nietknięte.

## Zakres i zmiany

- `NpcTalk`: ponownie sprawdzono wszystkie 21 283 rekordy. W shardach 0021–0086 poprawiono 41 tekstów, przede wszystkim ujednolicając „Władca/Władcy Empyreum”, „Ślady Empyreum” i „prąd wstępujący”. Trzy niezgodne wcześniej polskie kwestie ze źródłem `???` dopasowano do potwierdzonego kontekstu koreańskiego i japońskiego; statusy `pending` zachowano. W shardach 0001–0020 nie znaleziono nowych poprawek.
- `SkillString`: sprawdzono 22 726 rekordów we wszystkich 91 shardach. Wprowadzono 199 korekt, w tym ujednolicono 176 etykiet „Stagger Gauge Damage” do „pkt. obrażeń wskaźnika zachwiania równowagi”.
- `QuestString`: ponownie sprawdzono wszystkie 13 111 rekordów. Wprowadzono 291 korekt w języku, odmianie nazw lokacji i frakcji oraz spójności nazw; w jednym opisie naprawiono nadmiarowy tag `</>` wykryty walidatorem.
- `SkillAbnormalString`: sprawdzono 8 464 rekordy. W jednym z sześciu nowych wpisów klienta poprawiono „Skażenie Drany” na „Skażeniec Drany”, zgodnie z istniejącym odpowiednikiem w `String_str`; statusy i metadane zachowano.
- 16 dodatkowych tabel LOCRES (9 209 wpisów): 9 korekt terminologicznych i opisów. Wcześniej sprawdzona tabela NCUMG zachowuje swoje 9 korekt z poprzedniej fali.
- SDK i startup: ponownie sprawdzono 910 rekordów i poprawiono „Skontaktuj się z pomocy technicznej” na „Skontaktuj się z działem pomocy technicznej”.
- Kontrolnie potwierdzono mapowanie 153 042 kanonicznych ID, 9 569 rekordów cross-locale i 8 supplemental; nie wykryto brakujących rekordów ani rozjazdów ID/source. Pozostałe małe kategorie zostały sprawdzone wcześniej; 75 aliasów `CommandFunc` poprawnie pozostało technicznych. Całe 1 081 `CutsceneSubtitle` ma wcześniejszy pełny przegląd semantyczny; bieżąca walidacja nie wprowadziła zmian.

Łącznie w tej fali zgłoszono **545 poprawek pól `translation`** (41 NpcTalk + 3 korekty kontekstowe NpcTalk + 199 SkillString + 291 QuestString + 1 SkillAbnormalString + 9 LOCRES + 1 SDK). Trzy kwestie NpcTalk pokrywają się z kategorią NpcTalk i nie są doliczane ponownie poza tą sumą: liczba 545 obejmuje je w ramach pozycji 44 NpcTalk.

## Walidacja i źródła

- `validate_translations.py`: 164 858 rekordów, `errors: []`.
- Walidator cross-locale: 9 569 rekordów / 98 partii, `errors: []`.
- Walidator supplemental: 8 rekordów, `errors: []`.
- `python -m pytest -q tests`: **52 passed**.
- Nowy DAT: 153 042 rekordy, semantic round-trip zaliczony; 9 567 rekordów cross-locale oraz 8 supplemental włączonych do builda. SHA-256: `573ab60b48ec6f6c0a1f84dce1197365f32d2bcdfafcce8a3ca64044d4cbadb8`. Podglądowy ZIP przechodzi CRC; SHA-256: `75dd3a574b7be05d84f18f74192ba81db620f5b3aa1af56f01c5831a040e5c91`. Tego builda nie uruchomiono jeszcze w grze.

Pozostają **39 pozycji bez odzyskanego źródła**: 10 aliasów w `String_str`, 2 rekordy `String_ui` zawierające tylko `???` i 27 wartości Engine LOCRES zawierających `####`. Ponowny lokalny oraz publiczny audyt nie odzyskał ich dokładnej treści; dla aliasów Dream Crossroad/Nightmare dostępna baza wyświetla alias zamiast opisu. Nie dopisywano zgadywanych przekładów. Pełny wynik: `reports/agent-final-source-recovery-2026-10-14.md`, `reports/alias-public-source-recovery-2026-10-14.md` i `reports/crosslocale-gaps-audit-2026-10-14.md`. Integracja SDK/startup/pozostałych LOCRES z grą i test nowego DAT-u w runtime pozostają otwarte.
