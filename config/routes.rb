Rails.application.routes.draw do
  get  "/products",      to: "product#show"
  get  "/rules",         to: "rule#show"
  get  "/checkout",      to: "checkout#show"
  post "/checkout/scan", to: "checkout#scan"
  delete "/checkout",      to: "checkout#destroy"
end
