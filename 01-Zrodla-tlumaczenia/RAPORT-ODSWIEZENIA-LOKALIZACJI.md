# Installed client locale-source refresh — 2026-10-14

## Outcome

Re-read the language PAKs from the installed AION2 client and refreshed the cross-locale source audit to those exact files. The 9,569 existing cross-locale sidecar IDs are still valid, and every selected Korean source string matches the current Korean PAK. The existing Polish translations were preserved. Ten punctuation-only NPC lines were normalized to the Polish ellipsis `…`; their Japanese source is `…`, while Korean carries six dots or a damaged replacement glyph.

The current English, Japanese, German, Spanish, French, Portuguese, and Russian tables each contain 153,042 records. Korean contains 152,541 records and matches the English IDs it contains; 501 English IDs are absent from Korean. Korean has 268 IDs absent from its earlier saved source and 16 changed values. Japanese has 268 added IDs and 735 changed values. None of these changes altered the selected Korean source for an existing sidecar row.

The refreshed audit found alternate text for 9,569 of 9,577 English `???` values. Some are punctuation-only rather than dialogue; those sidecar translations now use `…`. The two remaining English UI placeholders have no usable text in the other installed locales. Ten `String_str` source aliases and 27 Engine LOCRES `####` entries also remain without recoverable wording.

## Validation

- `python scripts/inspect_locale_sources.py --copies <installed Aion2/Content/Paks/L10N/Text>` read all seven alternate locale PAKs and skipped the empty user-created `pl-PL` folder.
- `python scripts/audit_crosslocale_missing.py --copies <installed Aion2/Content/Paks/L10N/Text>` refreshed locale fingerprints, source tables, and exact-ID alternatives against the installed client.
- `python scripts/prepare_crosslocale_translations.py` preserved all 9,569 sidecar translations and refreshed their provenance.
- `python scripts/validate_translations.py`, both cross-locale validators, and `python -m pytest -q tests` pass.

The decoded locale tables remain under ignored `work/`; release sources include only the audit report and translation sidecars. The client has not been launched for a runtime check during this refresh.
