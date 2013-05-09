VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SpecExpectation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
''
' SpecExpectation v1.1.0
' (c) Tim Hall - https://github.com/timhall/Excel-TDD
'
' Provides various tests that can be performed for a provided value
'
' @dependencies
' @author tim.hall.engr@gmail.com
' @license: MIT (http://www.opensource.org/licenses/mit-license.php)
'
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ '

Public Enum ExpectResult
    Pass
    Fail
End Enum

Public ExpectValue As Variant
Public Result As ExpectResult
Public FailureMessage As String


' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ '
' Public Methods
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ '

''
' Check if the defined value is equal to the test value
'
' @param {Variant} Value
' --------------------------------------------- '

Public Sub ToEqual(Value As Variant)
    Dim failed As Boolean
    failed = False
    
    If IsError(Me.ExpectValue) Or IsError(Value) Then
        failed = True
    
    ' If both the values are doubles, use decimal notequal comparison
    ElseIf VarType(Me.ExpectValue) = vbDouble And VarType(Value) = vbDouble Then
        If CDec(Me.ExpectValue) <> CDec(Value) Then
            failed = True
        End If
        
    ' Otherwise use standard notequal comparison
    Else
        If Me.ExpectValue <> Value Then
            failed = True
        End If
    End If
    
    ' If test fails, create failure message
    If failed Then
        Fails CreateFailureMessage("to equal", Value)
    Else
        Passes
    End If
End Sub

''
' Check if the defined value is not equal to the test value
'
' @param {Variant} Value
' --------------------------------------------- '

Public Sub ToNotEqual(Value As Variant)
    If Not IsError(Me.ExpectValue) And Not IsError(Value) And Me.ExpectValue <> Value Then
        Passes
    Else
        Fails CreateFailureMessage("to not equal", Value)
    End If
End Sub

''
' Check if the test value is defined
' --------------------------------------------- '

Public Sub ToBeDefined()
    ' Make sure the value isn't empty or null
    ' (There may be other things that need to checked as well)
    If Not IsEmpty(Me.ExpectValue) And Not IsNull(Me.ExpectValue) Then
        Passes
    Else
        If VarType(Me.ExpectValue) = vbObject Then
            If Not Me.ExpectValue Is Nothing Then
                Passes
                Exit Sub
            End If
        End If
        
        Fails CreateFailureMessage("to be defined")
    End If
End Sub

''
' Check if the test value is undefined
' --------------------------------------------- '

Public Sub ToBeUndefined()
    ' If the value is empty or null, it is undefined
    If IsEmpty(Me.ExpectValue) Or IsNull(Me.ExpectValue) Or IsMissing(Me.ExpectValue) Then
        Passes
    Else
        If VarType(Me.ExpectValue) = vbObject Then
            If Me.ExpectValue Is Nothing Then
                Passes
                Exit Sub
            End If
        End If
        
        Fails CreateFailureMessage("to be undefined")
    End If
End Sub

''
' Check if the defined value is less than the test value
'
' @param {Variant} Value
' --------------------------------------------- '

Public Sub ToBeLessThan(Value As Variant)
    If IsError(Me.ExpectValue) Or IsError(Value) Or Me.ExpectValue >= Value Then
        Fails CreateFailureMessage("to be less than", Value)
    Else
        Passes
    End If
End Sub
Public Sub ToBeLT(Value As Variant)
    Call ToBeLessThan(Value)
End Sub

''
' Check if the defined value is less than or equal to the test value
'
' @param {Variant} Value
' --------------------------------------------- '

Public Sub ToBeLessThanOrEqualTo(Value As Variant)
    If IsError(Me.ExpectValue) Or IsError(Value) Or Me.ExpectValue > Value Then
        Fails CreateFailureMessage("to be less than or equal to", Value)
    Else
        Passes
    End If
End Sub
Public Sub ToBeLTE(Value As Variant)
    Call ToBeLessThanOrEqualTo(Value)
End Sub

''
' Check if the defined value is greater than the test value
'
' @param {Variant} Value
' --------------------------------------------- '

Public Sub ToBeGreaterThan(Value As Variant)
    If IsError(Me.ExpectValue) Or IsError(Value) Or Me.ExpectValue <= Value Then
        Fails CreateFailureMessage("to be greater than", Value)
    Else
        Passes
    End If
End Sub
Public Sub ToBeGT(Value As Variant)
    Call ToBeGreaterThan(Value)
End Sub

''
' Check if the defined value is greater than or equal to the test value
'
' @param {Variant} Value
' --------------------------------------------- '

Public Sub ToBeGreaterThanOrEqualTo(Value As Variant)
    If IsError(Me.ExpectValue) Or IsError(Value) Or Me.ExpectValue < Value Then
        Fails CreateFailureMessage("to be greater than or equal to", Value)
    Else
        Passes
    End If
End Sub
Public Sub ToBeGTE(Value As Variant)
    Call ToBeGreaterThanOrEqualTo(Value)
End Sub


' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ '
' Internal Methods
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ '

Private Sub Passes()
    Me.Result = ExpectResult.Pass
    If Err.Number <> 0 Then: Err.Clear
End Sub

Private Sub Fails(Message As String)
    Me.Result = ExpectResult.Fail
    Me.FailureMessage = Message
    If Err.Number <> 0 Then: Err.Clear
End Sub

Private Function GetStringForValue(Value As Variant) As String
    GetStringForValue = CStr(Value)
    If GetStringForValue = "" Then
        GetStringForValue = "(Undefined)"
    End If
End Function

Private Function CreateFailureMessage(Message As String, Optional Value As Variant) As String
    CreateFailureMessage = "Expected " & GetStringForValue(Me.ExpectValue) & " " & Message
    If Not IsMissing(Value) Then
        CreateFailureMessage = CreateFailureMessage & " " & GetStringForValue(Value)
    End If
End Function
