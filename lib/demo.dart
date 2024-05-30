import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void sendRegistrationEmail(String email, String username) async {
  final String usernameEmail = 'mobilelearning01@gmail.com';
  final String password =
      'olyv rgdo zbev shpj'; // Note: This should be securely managed

  final smtpServer = gmail(usernameEmail, password);

  final message = Message()
    ..from = Address(usernameEmail, 'Mobile Learning')
    ..recipients.add(email)
    ..subject = 'Welcome to ZenCart'
    ..html = '''
    <html>
      <body>
        <p>Hello $username,</p>
        <p>Thank you for registering at ZenCart! We are excited to have you.</p>
        <p>Best Regards,<br/>The ZenCart Team</p>
      </body>
    </html>
    ''';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. ${e.toString()}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

void logError(String error) {
  // Implement your error logging here
  print(error);
}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Send Registration Email'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              sendRegistrationEmail('dipakbar867@gmail.com', 'Dipak');
            },
            child: Text('Send Email'),
          ),
        ),
      ),
    );
  }
}
