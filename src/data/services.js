/**
 * Listini indicativi — confermare sempre in negozio dopo diagnosi gratuita.
 * @typedef {{ text: string, variant?: 'success' | 'accent' | 'muted' }} ServiceBadge
 * @typedef {{
 *   id: string,
 *   title: string,
 *   badge?: ServiceBadge,
 *   urgency?: string,
 *   leftCode: string,
 *   leftSub: string,
 *   rightCode: string,
 *   rightSub: string,
 *   price: string,
 *   priceNote: string,
 *   details: { bullets: string[], eta?: string }
 * }} RepairService
 * @typedef {{ id: string, name: string, subtitle: string, repairs: RepairService[] }} DeviceGroup
 */

/** @type {DeviceGroup[]} */
export const devices = [
  {
    id: 'iphone',
    name: 'Apple iPhone',
    subtitle: 'Display, batteria, connettori e altro.',
    repairs: [
      {
        id: 'ip-display',
        title: 'Sostituzione display',
        badge: { text: 'Più richiesto', variant: 'success' },
        leftCode: 'iPhone 13',
        leftSub: 'Serie 13 / 14 base',
        rightCode: 'Pannello',
        rightSub: 'OLED compatibile premium',
        price: 'da 89 €',
        priceNote: 'IVA inclusa, da confermare',
        details: {
          eta: 'Circa 45–60 minuti in laboratorio',
          bullets: [
            'Calibrazione True Tone dove applicabile.',
            'Test touch, sensori di prossimità e fotocamera frontale prima della consegna.',
            'Garanzia 30 giorni sull’intervento (esclusi danni da urto/liquidi).',
          ],
        },
      },
      {
        id: 'ip-batt',
        title: 'Sostituzione batteria',
        urgency: 'Prenota slot',
        leftCode: 'iPhone 12',
        leftSub: 'Stato salute sotto l’80%',
        rightCode: 'Kit batteria',
        rightSub: 'Cella certificata',
        price: 'da 59 €',
        priceNote: 'modello e disponibilità',
        details: {
          eta: 'Circa 30–45 minuti',
          bullets: [
            'Resoconto stato salute prima/dopo da impostazioni iOS.',
            'Sigilli e collanti professionali per tenuta polveri.',
          ],
        },
      },
    ],
  },
  {
    id: 'samsung',
    name: 'Samsung / Android',
    subtitle: 'Smartphone Android diffusi.',
    repairs: [
      {
        id: 'sam-display',
        title: 'Display assemblato',
        badge: { text: 'Express', variant: 'accent' },
        leftCode: 'Galaxy S21',
        leftSub: 'SM-G991B',
        rightCode: 'Service pack',
        rightSub: 'Display + frame originale',
        price: 'da 120 €',
        priceNote: 'ordine ricambio',
        details: {
          eta: '1–2 giorni lavorativi se ricambio non a magazzino',
          bullets: [
            'Impermeabilità non garantita dopo intervento (comunicazione in negozio).',
            'Backup consigliato prima del deposito.',
          ],
        },
      },
      {
        id: 'sam-usb',
        title: 'Connettore di ricarica',
        leftCode: 'A54',
        leftSub: 'Pulizia / sostituzione',
        rightCode: 'Modulo USB-C',
        rightSub: 'Parte saldatura flex',
        price: 'da 45 €',
        priceNote: 'post diagnosi',
        details: {
          eta: 'Circa 60 minuti',
          bullets: ['Diagnosi gratuita per distinguere sporco vs. connettore danneggiato.'],
        },
      },
    ],
  },
  {
    id: 'tablet',
    name: 'Tablet e iPad',
    subtitle: 'Schermi grandi, connettori cuffie, alimentazione.',
    repairs: [
      {
        id: 'ipad-glass',
        title: 'Vetro / touch',
        leftCode: 'iPad 10ª gen',
        leftSub: 'A2696',
        rightCode: 'Digitizer',
        rightSub: 'solo vetro o full assembly',
        price: 'da 95 €',
        priceNote: 'variante display',
        details: {
          eta: '2–4 ore o ritiro giorno successivo',
          bullets: [
            'Alcuni modelli richiedono display completo: preventivo dopo apertura controllata.',
          ],
        },
      },
    ],
  },
  {
    id: 'computer',
    name: 'Computer e Mac',
    subtitle: 'Notebook, upgrade, manutenzione.',
    repairs: [
      {
        id: 'mac-ssd',
        title: 'Upgrade SSD / RAM',
        leftCode: 'MacBook Air',
        leftSub: 'Intel / M1 (info in negozio)',
        rightCode: 'Storage',
        rightSub: 'NVMe / kit Apple',
        price: 'su preventivo',
        priceNote: 'post verifica',
        details: {
          eta: '24–72 ore',
          bullets: [
            'Clonazione dati su richiesta (disco funzionante).',
            'macOS reinstallabile con il tuo Apple ID.',
          ],
        },
      },
    ],
  },
];
