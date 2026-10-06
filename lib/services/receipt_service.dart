import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class ReceiptService {
  static Future<Uint8List> generateReceipt({
    required String customerName,
    required String accountNumber,
    required double amountDeposited,
    required String transactionDateTime,
    required dynamic transactionId,
  }) async {
    final pdf = pw.Document();

    final logoData = await rootBundle.load('assets/images/oloni_logo1.png');

    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final nairaFormat = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Image(logoImage, width: 150)),

              pw.SizedBox(height: 20),

              pw.Center(
                child: pw.Text(
                  'TRANSACTION RECEIPT',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Center(
                child: pw.Text(
                  'Oloni Bank',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                ),
              ),

              pw.SizedBox(height: 25),

              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(18),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    _buildRow('Customer Name', customerName),
                    _buildRow('Account Number', accountNumber),
                    _buildRow('Transaction Type', 'Deposit'),
                    _buildRow('Amount', nairaFormat.format(amountDeposited)),
                    _buildRow('Date & Time', transactionDateTime),
                    _buildRow('Transaction ID', '$transactionId'),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.green, width: 1.5),
                    borderRadius: pw.BorderRadius.circular(20),
                  ),
                  child: pw.Text(
                    '✓  SUCCESSFUL',
                    style: pw.TextStyle(
                      color: PdfColors.green,
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),

              pw.Spacer(),

              pw.Center(
                child: pw.Text(
                  'Thank you for banking with Oloni Bank.',
                  style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
                ),
              ),

              pw.SizedBox(height: 5),

              pw.Center(
                child: pw.Text(
                  'Your money. Your control.',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildRow(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 9),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
