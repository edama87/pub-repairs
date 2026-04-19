/**
 * Dati ricavati dal PDF «Listino Prezzi Aprile 2026» (laboratorio).
 * Dove il PDF non ha cella chiara → null (mostrato come «—»).
 */

export const listinoMeta = {
  titolo: 'Listino Aprile 2026',
  disclaimer:
    'Importi trascritti dal listino interno; la conferma avviene sempre in negozio dopo la diagnosi gratuita. * = non da listino / solo su ordinazione.',
};

/** @typedef {{ key: string, label: string, prices: (number|null)[] }} RepairRow */

/** @typedef {{ id: string, title: string, models: string[], repairs: RepairRow[] }} IphoneMatrix */

/** iPhone — tabella superiore del PDF (20 colonne). */
export const iphoneLegacy = {
  id: 'iphone-legacy',
  title: 'iPhone — modelli precedenti',
  models: [
    '11 Pro Max',
    '11 Pro',
    '11',
    'SE (2020–2022)',
    'XS Max',
    'XS',
    'XR',
    'X',
    '8 Plus',
    '8',
    '7 Plus',
    '7',
    '6s Plus',
    '6s',
    '6 Plus',
    '6',
    'SE (1ª gen.)',
    'Serie 5',
    '4s',
    '4',
  ],
  repairs: [
    {
      key: 'lcd',
      label: 'LCD + vetro',
      prices: [119, 99, 89, 89, 99, 79, 89, 79, 79, 79, 79, 69, 49, 49, 49, 49, 49, 49, 49, 49],
    },
    {
      key: 'vetroPost',
      label: 'Vetro posteriore',
      prices: [
        89, 89, 89, 79, 79, 79, 79, 79, 79, 79, 29, 29, null, null, null, null, null, null, null, null,
      ],
    },
    {
      key: 'batteria',
      label: 'Batteria',
      prices: [59, 59, 59, 59, 59, 49, 59, 49, 49, 49, 49, 49, 49, 39, 39, 39, 49, 39, 29, 29],
    },
    {
      key: 'dock',
      label: 'Dock di ricarica',
      prices: [69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 39, 39, 39, 39, 39, 39, 39, 39],
    },
    {
      key: 'speaker',
      label: 'Cassa speaker / altoparlante',
      prices: [59, 59, 59, 49, 59, 59, 59, 59, 49, 49, 49, 49, 39, 39, 39, 39, 39, 39, 39, 39],
    },
    {
      key: 'earpiece',
      label: 'Cassa vivavoce / suoneria',
      prices: [59, 59, 59, 49, 59, 59, 59, 59, 49, 49, 49, 49, 39, 39, 39, 39, 39, 39, 39, 39],
    },
  ],
};

/** iPhone — tabella inferiore del PDF (20 modelli; alcune righe hanno meno celle → null). */
export const iphoneRecent = {
  id: 'iphone-recent',
  title: 'iPhone — modelli recenti',
  models: [
    '16e',
    '16 Pro Max',
    '16 Pro',
    '16',
    '16 Plus',
    '15 Pro Max',
    '15 Pro',
    '15',
    '15 Plus',
    '14 Pro Max',
    '14 Pro',
    '14',
    '14 Plus',
    '13 Pro Max',
    '13 Pro',
    '13',
    '13 mini',
    '12 Pro Max',
    '12 / 12 Pro',
    '12 mini',
  ],
  repairs: [
    {
      key: 'lcd',
      label: 'LCD + vetro',
      prices: [
        199, 329, 249, 199, 219, 329, 249, 199, 219, 229, 199, 149, 139, 149, 129, 119, null, null, null, null,
      ],
    },
    {
      key: 'vetroPost',
      label: 'Vetro posteriore',
      prices: [
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        139,
        139,
        null,
        null,
        129,
        129,
        129,
        129,
        119,
        119,
        119,
      ],
    },
    {
      key: 'batteria',
      label: 'Batteria',
      prices: [
        89, 89, 89, 89, 89, 89, 89, 89, 79, 79, 79, 79, 69, 69, 69, null, null, null, null, null,
      ],
    },
    {
      key: 'dock',
      label: 'Dock di ricarica',
      prices: [
        129, 129, 129, 129, 129, 99, 99, 99, 99, 89, 89, 89, 89, 89, 89, 89, null, null, null, null,
      ],
    },
    {
      key: 'speaker',
      label: 'Cassa speaker / altoparlante',
      prices: [
        99, 89, 89, 89, 89, 89, 89, 89, 89, 89, 89, 89, 89, 89, 89, 89, null, null, null, null,
      ],
    },
    {
      key: 'earpiece',
      label: 'Cassa vivavoce / suoneria',
      prices: [99, 89, 89, 89, 89, 79, 79, 79, 79, 79, 79, 79, 79, 69, 69, 69, null, null, null, null],
    },
  ],
  footnote: '** Solo su ordinazione (nota sul PDF originale).',
};

/**
 * iPad — seconda pagina PDF (layout a blocchi; prezzi indicativi per fascia).
 * @typedef {{ titolo: string, righe: { voce: string, prezzo: string }[], nota?: string }} IpadBlocco
 */

export const ipadListino = {
  id: 'ipad',
  title: 'iPad',
  blocks: [
    {
      titolo: 'Air (2013) · Air 2 · Air 3 · mini 4',
      nota: 'Codici es. A1474, A1475/76, A1566, A1567, A2152, A2123, A1538, A1550',
      righe: [
        { voce: 'Sostituzione display (LCD + vetro)', prezzo: 'da 149 €' },
        { voce: 'Solo vetro', prezzo: 'da 79 €' },
      ],
    },
    {
      titolo: 'Pro 9,7" (2016) · Pro 10,5" (2017)',
      nota: 'A1673, A1674/75, A1701, A1709',
      righe: [
        { voce: 'Display / vetro (listino Aprile 2026)', prezzo: 'da 149 € / da 79 €' },
      ],
    },
    {
      titolo: 'iPad 7a–9a gen · 6a–5a gen · 4a–1a gen',
      nota: 'Fasce cumulative sul PDF (€ 149 / € 149 / € 99 / € 89 / € 49)',
      righe: [
        { voce: 'Fascia prezzo indicativa (ordine dal più recente al più datato nel foglio)', prezzo: '149 € · 149 € · 99 € · 89 € · 49 €' },
      ],
    },
    {
      titolo: '10a gen (2022) WiFi / LTE / CINA',
      nota: 'A2696, A2757, A2777–A3162',
      righe: [{ voce: 'Vetro / interventi (vedi listino completo)', prezzo: 'da 149 €' }],
    },
    {
      titolo: '10a gen (2025) · iPad Air / iPad mini',
      nota: 'A3354, A3355, A3356 — riga «iPad Air iPad Mini iPad»',
      righe: [{ voce: 'Listino Aprile 2026', prezzo: 'da 169 €' }],
    },
    {
      titolo: 'mini 3 (2014)',
      nota: 'A1599, A1600',
      righe: [
        { voce: 'Display', prezzo: 'da 119 €' },
        { voce: 'Solo vetro', prezzo: 'da 79 €' },
      ],
    },
  ],
};

export const altriDispositivi = {
  title: 'Altri dispositivi',
  body:
    'Tablet Android, smartphone non Apple, Mac e PC: diagnosi gratuita in negozio e preventivo dedicato. Il listino PDF Aprile 2026 copre principalmente gamma Apple iPhone/iPad.',
};

export const iphoneCategories = [iphoneLegacy, iphoneRecent];
