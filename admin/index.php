<?php
declare(strict_types=1);
?><!doctype html>
<html lang="it">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Admin — OfficinaePhone</title>
    <link rel="stylesheet" href="./admin.css" />
  </head>
  <body>
    <header class="topbar">
      <div class="topbar__inner">
        <div class="brand">OfficinaePhone Admin</div>
        <div class="spacer"></div>
        <button class="btn btn--ghost" id="logoutBtn" hidden>Logout</button>
      </div>
    </header>

    <main class="container">
      <section id="loginPanel" class="panel">
        <h1>Accesso</h1>
        <p class="muted">Effettua login per gestire dispositivi, riparazioni e prezzi.</p>
        <form id="loginForm" class="form">
          <label class="field">
            <span>Username</span>
            <input name="username" autocomplete="username" required />
          </label>
          <label class="field">
            <span>Password</span>
            <input name="password" type="password" autocomplete="current-password" required />
          </label>
          <button class="btn" type="submit">Entra</button>
          <p id="loginError" class="error" role="alert" aria-live="polite"></p>
        </form>
        <noscript>
          <p class="error">JavaScript è disattivato: l’admin richiede JavaScript per funzionare.</p>
        </noscript>
      </section>

      <section id="appPanel" class="panel" hidden>
        <div class="tabs" role="tablist" aria-label="Sezioni admin">
          <button class="tab" role="tab" id="tab-devices" data-tab="devices" aria-selected="true">Dispositivi</button>
          <button class="tab" role="tab" id="tab-repairs" data-tab="repairs" aria-selected="false">Riparazioni</button>
          <button class="tab" role="tab" id="tab-prices" data-tab="prices" aria-selected="false">Prezzi</button>
        </div>

        <section class="tabPanel" id="panel-devices" role="tabpanel" aria-labelledby="tab-devices">
          <div class="row row--between">
            <h2>Dispositivi</h2>
            <button class="btn" id="addDeviceBtn">Aggiungi</button>
          </div>
          <div class="row">
            <label class="field field--inline">
              <span>Categoria</span>
              <select id="deviceCategoryFilter">
                <option value="">Tutte</option>
                <option value="iphone-recent">iPhone recenti</option>
                <option value="iphone-legacy">iPhone precedenti</option>
                <option value="ipad">iPad</option>
                <option value="other">Altro</option>
              </select>
            </label>
            <button class="btn btn--ghost" id="refreshDevicesBtn">Aggiorna</button>
          </div>
          <div class="tableWrap">
            <table class="table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Categoria</th>
                  <th>Label</th>
                  <th>Short</th>
                  <th>Ordine</th>
                  <th>Attivo</th>
                  <th></th>
                </tr>
              </thead>
              <tbody id="devicesTbody"></tbody>
            </table>
          </div>
        </section>

        <section class="tabPanel" id="panel-repairs" role="tabpanel" aria-labelledby="tab-repairs" hidden>
          <div class="row row--between">
            <h2>Riparazioni</h2>
            <button class="btn" id="addRepairBtn">Aggiungi</button>
          </div>
          <div class="row">
            <label class="field field--inline">
              <span>Scope</span>
              <select id="repairScopeFilter">
                <option value="">Tutti</option>
                <option value="iphone">iPhone</option>
                <option value="ipad">iPad</option>
                <option value="other">Altro</option>
              </select>
            </label>
            <button class="btn btn--ghost" id="refreshRepairsBtn">Aggiorna</button>
          </div>
          <div class="tableWrap">
            <table class="table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Scope</th>
                  <th>Key</th>
                  <th>Label</th>
                  <th>Ordine</th>
                  <th>Attivo</th>
                  <th></th>
                </tr>
              </thead>
              <tbody id="repairsTbody"></tbody>
            </table>
          </div>
        </section>

        <section class="tabPanel" id="panel-prices" role="tabpanel" aria-labelledby="tab-prices" hidden>
          <div class="row row--between">
            <h2>Prezzi</h2>
            <button class="btn" id="addPriceBtn">Aggiungi / aggiorna</button>
          </div>
          <p class="muted">Un prezzo è (dispositivo, riparazione) → importo. Se esiste già, verrà aggiornato.</p>
          <div class="row">
            <button class="btn btn--ghost" id="refreshPricesBtn">Aggiorna</button>
          </div>
          <div class="tableWrap">
            <table class="table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Dispositivo</th>
                  <th>Riparazione</th>
                  <th>Prezzo</th>
                  <th>Note</th>
                  <th>Attivo</th>
                  <th></th>
                </tr>
              </thead>
              <tbody id="pricesTbody"></tbody>
            </table>
          </div>
        </section>
      </section>
    </main>

    <dialog class="dialog" id="editDialog">
      <form method="dialog" class="dialog__inner" id="editForm">
        <h3 id="dialogTitle">Modifica</h3>
        <div id="dialogBody"></div>
        <div class="dialog__actions">
          <button class="btn btn--ghost" value="cancel">Annulla</button>
          <button class="btn" id="saveBtn" value="save">Salva</button>
        </div>
        <p id="dialogError" class="error" role="alert" aria-live="polite"></p>
      </form>
    </dialog>

    <script src="./admin.js" defer></script>
  </body>
</html>

