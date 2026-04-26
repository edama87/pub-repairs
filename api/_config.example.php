<?php
/**
 * Copia questo file in `_config.local.php` e inserisci i parametri reali.
 * `_config.local.php` NON va versionato.
 */
return [
  'db' => [
    'host' => '127.0.0.1',
    'port' => 3306,
    'name' => 'officinaephone',
    'user' => 'officinaephone_user',
    'pass' => 'change-me',
    'charset' => 'utf8mb4',
  ],
  /**
   * Imposta su true in produzione (cookie sicuri e SameSite più restrittivo).
   * Su localhost spesso serve false.
   */
  'is_prod' => false,
  /**
   * Aggiorna con un valore random lungo.
   * Serve per firmare token (CSRF) e altri segreti applicativi.
   */
  'app_secret' => 'change-me-to-a-long-random-string',
];

