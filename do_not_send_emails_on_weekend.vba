'1.	Open the VBA Editor using Alt+F11 and expand Project1 until you see ThisOutlookSession. Double click on ThisOutlookSession and paste the macro in the right pane.
'2.	When in Outlook press Alt F11
'3.	Expand Project1 to see ThisOutlookSession
'4.	Double  click ThisOutlookSession and paste the code below in the right pane. 
'5.	Adjust the Monday morning time you want the mails to start going out. Right now it is 9 am. Save. Close.
'6.	Any mail you send on Saturday and Sunday will be held in your Outbox until Monday 9 am.
'7.	To escape this rule for some emails which you want to go out straight away you can edit your subject and insert three spaces anywhere (at the end will be least noticeable)





Private Sub Application_ItemSend(ByVal Item As Object, Cancel As Boolean)
    Dim Mail As Outlook.MailItem
    Dim WkDay As String
    Dim MinNow As Integer
    Dim SendHour As Integer
    Dim SendDate As Date
    Dim SendNow As String
    Dim MonMorning As Integer
    Dim NoOffPeakTolerance As Boolean
    
    '''''''''''''''''''''''''''''''''''''''''''''''''''
    '''''''   ver 0.01 Fri Jan 9, 2015  '''''''''''''''
    ' Created by rawman
    ' Code to capture Send Event and check if the email
    ' is being sent on weekend or even off hours during
    ' weekdays (configurable). If so will be scheduled
    ' to be delivered on the next working hour
    ' unless an escape string is used in the subject
    ' "bbb" (three spaces) is default escape string
    '''''''''''''''''''''''''''''''''''''''''''''''''''
    '''''''''''''''''''''''''''''''''''''''''''''''''''
    '''''''   ver x.xx Ddd Mmm D, YYYY  '''''''''''''''
    ' change log:
    '
    ‘ backlog: 
    ' Implement NoOffPeakTolerance
    ' Implement alternate Body based escape string so conversation view stays intact
    ' Initialize the ‘Do Not Deliver before’ every time the email is Sent and then evaluate if the email needs to be queued or sent right away
    '       It is likely that you would realize after having hit send that the email should go right away. Naturally you would hunt down that email in your outbox – add three spaces to subject and hit Send. But the email will remain in your outbox refusing to go.This is because ‘Do not Deliver before’ is still stamped on the email.

    
    
    ' >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ' >>>> User Configurable Values
    'Assuming you want to send mails at 9 am on monday morning
    'Adjust + part to whatever you want: 8 for 8 am
    MonMorning = 9
    
    'The below string if present in subject will cause us to abort: the mail will not be delayed
    EscapeStr = "   "
    
    'Set Tolerance for off peak hours
    ' **** Not fully implemented yet ******
    ' *************************************
    'If NoOffPeakTolerance set to True early morning and late evening mails will be deferred to next day
    NoOffPeakTolerance = False ' !!!!! do not change in this version
    ' <<<<  User Configurable Values
    ' <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    
    If TypeOf Item Is Outlook.MailItem Then
        Set Mail = Item
        'Check subject for escape string
        If InStr(Mail.Subject, EscapeStr) Then
            Exit Sub
        End If
    Else
        Exit Sub
    End If


    'Set Variables
    SendDate = Now()
    SendHour = Hour(Now)
    MinNow = Minute(Now)
    WkDay = Weekday(Now)
    SendNow = Y
    
    If NoOffPeakTolerance Then
       ‘ Do something
    End If
    
    'Check if Sunday
    If WkDay = 1 Then
        SendHour = MonMorning - SendHour
        SendDate = DateAdd("d", 1, SendDate)
        SendDate = DateAdd("h", SendHour, SendDate)
        SendDate = DateAdd("n", -MinNow, SendDate)
        SendNow = N
    End If
    
    'Check if Saturday
    If WkDay = 7 Then
        SendHour = MonMorning - SendHour
        SendDate = DateAdd("d", 2, SendDate)
        SendDate = DateAdd("h", SendHour, SendDate)
        SendDate = DateAdd("n", -MinNow, SendDate)
        SendNow = N
    End If
    
    'Send the Email
    If SendNow = N Then
        Mail.DeferredDeliveryTime = SendDate
    End If
    'As we are now intercepting the send event the explict send is not needed
    'Mail.Send

End Sub


