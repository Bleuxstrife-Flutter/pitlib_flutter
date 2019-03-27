package pit.com.pitpayment;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.midtrans.sdk.corekit.callback.CardTokenCallback;
import com.midtrans.sdk.corekit.core.MidtransSDK;
import com.midtrans.sdk.corekit.core.SdkCoreFlowBuilder;
import com.midtrans.sdk.corekit.models.CardTokenRequest;
import com.midtrans.sdk.corekit.models.TokenDetailsResponse;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static android.app.Activity.RESULT_OK;

/**
 * PitPaymentPlugin
 */
public class PitPaymentPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
    private Context context;
    private Activity activity;
    private static final int REQUEST_RENT_FEE = 4569;
    private String token;
    private Result result;
    private static final String VT_KEY_DEBUG = "VT-client-j_y7RRFZJETHsqMe";
    private static final String VT_KEY_PRODUCTION = "VT-client-ZgRC-r-WntD2epbI";
    private static final String BASE_URL_DEBUG = "https://api.sandbox.veritrans.co.id/v2/transactions";
    private static final String BASE_URL_PRODUCTION = "https://api.veritrans.co.id/v2/transactions";

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "pit_payment");
        PitPaymentPlugin plugin = new PitPaymentPlugin();
        channel.setMethodCallHandler(plugin);

        SdkCoreFlowBuilder.init()
                .setContext(registrar.context())
                .setClientKey(VT_KEY_DEBUG)
                .setMerchantBaseUrl(BASE_URL_DEBUG)
                .enableLog(true)
                .buildSDK();

        plugin.context = registrar.context();
        plugin.activity = registrar.activity();

        registrar.addActivityResultListener(plugin);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("generateCreditCardToken")) {
            try {
                JSONObject jsonObject = new JSONObject(call.argument("creditCard").toString());

                String creditCardNumber = jsonObject.getString("creditCardNumber");
                String expiryMonth = jsonObject.get("expiryMonth").toString();
                String expiryYear = jsonObject.get("expiryYear").toString();
                String cvv = jsonObject.get("cvv").toString();
                double amount = jsonObject.getDouble("amount");
                this.result = result;

                submitCreditCard(creditCardNumber, cvv, expiryMonth, expiryYear, amount);
            } catch (JSONException e) {
                result.error("error: " + e.getMessage(), "", "");
            }
        } else {
            result.notImplemented();
        }
    }

    private void submitCreditCard(String cardNumber, String cvv, String expireMonth,
                                  String expireYear, double totalPrice) {
        CardTokenRequest cardTokenRequest = new CardTokenRequest(
                // Card number
                cardNumber,
                cvv,
                expireMonth,
                expireYear,
                MidtransSDK.getInstance().getClientKey());

        cardTokenRequest.setGrossAmount(totalPrice);

        cardTokenRequest.setSecure(true);

        MidtransSDK.getInstance().getCardToken(cardTokenRequest, new CardTokenCallback() {
            @Override
            public void onSuccess(TokenDetailsResponse tokenDetailsResponse) {
                String token = tokenDetailsResponse.getTokenId();
                String url = tokenDetailsResponse.getRedirectUrl();

                PitPaymentPlugin.this.token = token;
                Intent intent = new Intent(activity, WebviewVerifyActivity.class);
                intent.putExtra(WebviewVerifyActivity.EXTRA_URL, url);
                activity.startActivityForResult(intent, REQUEST_RENT_FEE);
            }

            @Override
            public void onFailure(TokenDetailsResponse tokenDetailsResponse, String errorMessage) {
                result.error("error: " + errorMessage, "", "");
            }

            @Override
            public void onError(Throwable throwable) {
                result.error("error: " + throwable.getMessage(), "", "");
            }
        });
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        if (i == REQUEST_RENT_FEE && i1 == RESULT_OK) {
            if (result != null) result.success("ccToken: " + (token == null ? "" : token));
        }
        return false;
    }
}
