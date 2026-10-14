# Tłumaczenie AION2

Pliki JSONL zawierają jeden rekord na linię. Zmieniaj wyłącznie `translation` i `status`. `id` oraz `source` muszą pozostać identyczne. Zachowaj UTF-8, tagi, parametry, sekwencje sterujące, znaczniki i nowe linie zapisane jako JSON escapes.

Status `pending` oznacza brak tłumaczenia. `draft` oznacza szkic, również wygenerowany przez model. `reviewed` wymaga redakcji. `technical` oznacza celowo zachowaną identyczną wartość techniczną (np. aliasy komend i znaczniki DNT), a nie przetłumaczony tekst. Nie oznaczaj tłumaczenia jako zweryfikowane w grze bez rzeczywistego testu.

Przyjmij krótkie, naturalne polskie etykiety interfejsu. Opisy akcji w trybie rozkazującym, opisy funkcji w czasie teraźniejszym. Nie tłumacz placeholderów, nazw klawiszy ani technicznych komend. Nazwy własne zachowuj do czasu przyjęcia wspólnego słownika. Nie dopisuj informacji nieobecnych w źródle.

Wstępna terminologia: Settings = Ustawienia; Inventory = Ekwipunek; Skill = Umiejętność; Quest = Zadanie; Market = Rynek; Guild = Gildia; Party = Drużyna; Alliance = Sojusz; Quickslot = Szybki slot; Consumables = Przedmioty użytkowe; Target = Cel; Essence Extraction = Pozyskiwanie esencji.

Nazwa waluty ze źródła: Kina. Zachowaj tę nazwę; nie zamieniaj na Kinah z wcześniejszej gry. Zachowuj też podział na akapity w odpowiadających miejscach, a nie tylko łączną liczbę znaków nowej linii.

Ustalane podczas redakcji etykiety: Daeva Pass = Przepustka Daevy; Substance Morph = Transmutacja substancji; Pet = Wierzchowiec; Pets = Wierzchowce; Genus Insight = Wnikliwość rodzaju; Legion = Legion; Abyss Points = Punkty Otchłani; Complimentary Quna = Bezpłatna Quna; Paid Quna = Płatna Quna; Pending Quna = Oczekująca Quna. Guild pozostaje Gildia. Nie tłumacz nazw walut Quna i Kina. Odmieniaj nazwy funkcji naturalnie w zdaniach; wcześniejsze szkice mogą wymagać ujednolicenia.

Podział na kategorie jest oparty na prefiksach identyfikatorów; nie stanowi pełnego opisu semantycznego. Manifest każdej tabeli wskazuje liczbę rekordów, pliki partii i SHA-256 źródła.

Źródła zawierające wyłącznie `???` pozostaw jako `pending`: nie zawierają tekstu możliwego do przełożenia. Nie zaliczaj ich do szkiców ani aliasów technicznych. Zgłaszaj je osobno.

Audyt innych języków: reports/INNE-JEZYKI.md. Nie używaj automatycznie wspólnego ID jako dowodu zgodności wersji. Tłumaczenie źródła pomocniczego wymaga ustalenia pochodzenia, sprawdzenia kontekstu i kontroli formatowania względem tego źródła; obecne source angielskie pozostaje niezmienione.

Ustalenia dotyczące rodzaju postaci i nazw: NAZWY-I-POSTACIE.md. Nie przenoś rodzaju NPC na gracza. Dredgion zachowuje nazwę z gry; nie zamieniaj na drednot.

Ustalona etykieta stanu przedmiotu: `(Bound)` = `(Przypisane)`. Jest to stała etykieta interfejsu, niezależna od rodzaju nazwy przedmiotu. Zachowuj podwójne nawiasy, jeśli występują w źródle. MP = PM (punkty many), HP = PŻ (punkty życia). Nie dopisuj znaku procentu do placeholdera szansy, jeśli źródło go nie zawiera; wątpliwość źródła zgłoś osobno.
