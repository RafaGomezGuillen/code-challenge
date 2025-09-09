import { useEffect, useState } from "react";
import { getCheckout, scanProduct, clearCheckout } from "./api/checkout.api";
import { getProducts } from "./api/product.api";
import { getRules } from "./api/rule.api";

function App() {
  const [products, setProducts] = useState([]);
  const [rules, setRules] = useState([]);
  const [checkout, setCheckout] = useState({ items: [], total: "0.00€" });
  const [loading, setLoading] = useState(false);

  // Load initial data
  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    const [prod, rule, cart] = await Promise.all([
      getProducts(),
      getRules(),
      getCheckout(),
    ]);
    setProducts(prod);
    setRules(rule);
    setCheckout(cart);
  };

  const handleAdd = async (code) => {
    setLoading(true);
    try {
      await scanProduct(code);
      const cart = await getCheckout();
      setCheckout(cart);
    } finally {
      setLoading(false);
    }
  };

  const handleClear = async () => {
    await clearCheckout();
    const cart = await getCheckout();
    setCheckout(cart);
  };

  return (
    <div className="min-h-screen bg-gray-100 p-4 flex flex-col items-center">
      <h1 className="text-2xl font-bold mb-6 text-center">Code challenge</h1>

      {/* Products */}
      <div className="w-full bg-white shadow rounded-lg p-4 mb-6">
        <h2 className="text-xl font-semibold mb-3">Products</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          {products.map((p) => (
            <div
              key={p.id}
              className="border rounded-lg p-3 flex flex-col items-start"
            >
              <span className="font-bold">{p.name}</span>
              <span className="text-gray-600">{p.code}</span>
              <span className="text-green-600 font-semibold">{p.price}€</span>
              <button
                className="mt-2 px-3 py-1 bg-blue-600 text-white text-sm rounded hover:bg-blue-700"
                onClick={() => handleAdd(p.code)}
                disabled={loading}
                title="Add to cart"
              >
                Add to cart
              </button>
            </div>
          ))}
        </div>
      </div>

      {/* Rules */}
      <div className="w-full bg-white shadow rounded-lg p-4 mb-6">
        <h2 className="text-xl font-semibold mb-3">Discount rules</h2>
        <ul className="list-disc pl-5 space-y-1">
          {rules.map((r, idx) => (
            <li key={idx}>
              <span className="font-semibold">{r.applies_to}:</span>{" "}
              {r.description}
            </li>
          ))}
        </ul>
      </div>

      {/* Checkout */}
      <div className="w-full bg-white shadow rounded-lg p-4">
        <h2 className="text-xl font-semibold mb-3">Cart</h2>
        {checkout.items.length === 0 ? (
          <p className="text-gray-500">Your cart is empty.</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full border">
              <thead className="bg-gray-200">
                <tr>
                  <th className="px-3 py-2 text-left">Code</th>
                  <th className="px-3 py-2 text-left">Product</th>
                  <th className="px-3 py-2 text-right">Price</th>
                  <th className="px-3 py-2 text-right">Quantity</th>
                </tr>
              </thead>
              <tbody>
                {checkout.items.map((item, idx) => (
                  <tr key={idx} className="border-t">
                    <td className="px-3 py-2">{item.code}</td>
                    <td className="px-3 py-2">{item.name}</td>
                    <td className="px-3 py-2 text-right">
                      {item.price.toFixed(2)}€
                    </td>
                    <td className="px-3 py-2 text-right">{item.quantity}</td>
                  </tr>
                ))}
              </tbody>
              <tfoot>
                <tr className="font-bold border-t">
                  <td colSpan="3" className="px-3 py-2 text-right">
                    Total
                  </td>
                  <td className="px-3 py-2 text-right">{checkout.total}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        )}

        <button
          title="Clear cart"
          onClick={handleClear}
          className="mt-4 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
        >
          Clear Cart
        </button>
      </div>
    </div>
  );
}

export default App;
