Rails.application.routes.draw do
  get  "/products",      to: "checkout#products"
  get  "/rules",         to: "checkout#rules"
  post "/checkout/scan", to: "checkout#scan"
  get  "/checkout",      to: "checkout#show"
  delete "/checkout",      to: "checkout#destroy"
end
