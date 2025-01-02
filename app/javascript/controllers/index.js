// import { application } from "./application"
// import StarRatingController from "./star_rating_controller"
// application.register("star-rating", StarRatingController)

// import { Application } from "@hotwired/stimulus"
// import StarRatingController from "./star_rating_controller"

// const application = Application.start()
// window.Stimulus = application
// application.register("star-rating", StarRatingController)

// import { Application } from "@hotwired/stimulus"
// import StarRatingController from "./star_rating_controller"

// const application = Application.start()
// window.Stimulus = application
// application.register("star-rating", StarRatingController)

// const importMap = JSON.parse(document.querySelector('script[type="importmap"]').textContent);
// console.log(importMap.imports);
// import(importMap.imports["controllers/star_rating_controller"]).then(console.log);

// import("@hotwired/stimulus").then(module => {
//   const app = module.Application.start();
//   window.Stimulus = app;

//   // スターレーティングコントローラーをインポートして登録
//   import(importMap.imports["controllers/star_rating_controller"]).then(controller => {
//       app.register("star-rating", controller.default);
//       console.log("Registered controllers:", app.controllers);
//   });
// });

import { application } from "./application"
import StarRatingController from "./star_rating_controller"
application.register("star-rating", StarRatingController)