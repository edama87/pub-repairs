import './styles/base.css';
import './styles/layout.css';
import './styles/components.css';
import './styles/bokeh.css';

import { mountChrome, setYear } from './chrome.js';

mountChrome('contatti');
setYear();
