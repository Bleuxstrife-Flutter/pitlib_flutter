import 'package:flutter/material.dart';

class Dict {
  final Locale locale;

  Dict(this.locale);

  Map<String, Map<String, String>> _localizedValues = {
    'id': {
      'credit_card_number': 'Nomor Kartu Kredit',
      'cvv_number': 'Nomor CVV',
      'mandiri_debit_card_number': 'Nomor Kartu Debit Mandiri',
      'mandiri_bill_title': 'Informasi Mandiri Bill Payment',
      'mandiri_bill_content_1': 'Pembayaran bisa dilakukan melalui ATM Mandiri atau Mandiri Internet Banking',
      'mandiri_bill_content_2': 'Mohon untuk melakukan pembayaran secepatnya - kode pembayaran akan kadaluarsa dalam 24 jam',
      'mandiri_bill_content_3': 'Transaksi minimal dengan ATM Mandiri adalah Rp. 50,000 dan Mandiri Internet Banking adalah Rp. 10,000',
      'mandiri_bill_content_4': 'Detil pemesanan mobil akan dikirimkan melalui email',
      'permata_va_title': 'Langkah-langkah ATM Transfer',
      'permata_va_content_1': 'Klik tombol Submit',
      'permata_va_content_2': 'Kamu akan menerima kode unik dan instruksi untuk membayarnya (anda bisa menerima instruksinya melalui email)',
      'permata_va_content_3': 'Mohon melakukan pembayaran melalui Jaringan ATM Prima (BCA), ATM Bersama (Mandiri) atau Alto (Permata)',
      'permata_va_content_4': 'Apabila pembayaran sudah selesai, anda akan menerima email konfirmasi',
      'submit': 'Submit',
      'your_security_code': 'Kode Keamanan anda',
    },
    'en': {
      'credit_card_number': 'Credit Card Number',
      'cvv_number': 'CVV Number',
      'mandiri_debit_card_number': 'Mandiri Debit Card Number',
      'mandiri_bill_title': 'Mandiri Bill Payment Information',
      'mandiri_bill_content_1': 'Payment can be made through Mandiri ATM or Mandiri Internet Banking',
      'mandiri_bill_content_2': 'Please make a payment as soon as possible - the payment code will expire within 24 hours',
      'mandiri_bill_content_3': 'Minimum transaction using Mandiri ATM is IDR 50,000 and Mandiri Internet Banking is IDR 10,000',
      'mandiri_bill_content_4': 'Order details will be sent via email',
      'permata_va_title': 'ATM Transfer Step-by-Step',
      'permata_va_content_1': 'Click the Submit button',
      'permata_va_content_2': 'You will receive a unique account number and instructions on how to pay (you can receive instructions via your email)',
      'permata_va_content_3': 'Please complete payment through the Prima (BCA), ATM Bersama (Mandiri) or Alto (Permata) ATM Network',
      'permata_va_content_4': 'Once payment is complete, you will receive a confirmation email',
      'submit': 'Submit',
      'your_security_code': 'Your Security Code',
    },
  };

  String getString(String value) {
    Map<String, String> localizedValue = _localizedValues[locale.languageCode] ?? _localizedValues["en"];

    return localizedValue[value] ?? _localizedValues["en"][value] ?? "Raw $value";
  }
}
