// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// stimulusが読み込めなかったため暫定対応
const importMap = JSON.parse(document.querySelector('script[type="importmap"]').textContent);

import("@hotwired/stimulus").then(module => {
  const app = module.Application.start();
  window.Stimulus = app;
  import(importMap.imports["controllers/star_rating_controller"]).then(controller => {
    app.register("star-rating", controller.default);
  });
});

import "@hotwired/turbo-rails"
import "chartkick"
import "Chart.bundle"