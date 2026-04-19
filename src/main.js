import './styles/base.css';
import './styles/layout.css';
import './styles/components.css';

import { mountServiceList } from './ui/serviceCards.js';
import { initNavigation } from './nav.js';

const yearEl = document.getElementById('year');
if (yearEl) yearEl.textContent = String(new Date().getFullYear());

mountServiceList(document.getElementById('service-root'));
initNavigation();
