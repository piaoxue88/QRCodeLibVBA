VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BitSequence"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_buffer As Object ' Is Dictionary
Private m_bitCounter As Long
Private m_space      As Long

Private Sub Class_Initialize()
    Call Clear
End Sub

Public Property Get Length() As Long
    Length = m_bitCounter
End Property

Public Sub Clear()
    Set m_buffer = CreateObject("Scripting.Dictionary")
    m_bitCounter = 0
    m_space = 0
End Sub

Public Sub Append(ByVal data As Long, ByVal bitLength As Long)
    Dim remainingLength As Long
    remainingLength = bitLength

    Dim remainingData As Long
    remainingData = data

    Dim temp As Byte

    Do While remainingLength > 0
        If m_space = 0 Then
            m_space = 8
            Call m_buffer.Add(m_buffer.Count, CByte(&H0))
        End If

        temp = m_buffer(m_buffer.Count - 1)

        If m_space < remainingLength Then
            temp = CByte(temp Or remainingData \ (2 ^ (remainingLength - m_space)))

            remainingData = remainingData And ((2 ^ (remainingLength - m_space)) - 1)

            m_bitCounter = m_bitCounter + m_space
            remainingLength = remainingLength - m_space
            m_space = 0
        Else
            temp = CByte(temp Or remainingData * (2 ^ (m_space - remainingLength)))

            m_bitCounter = m_bitCounter + remainingLength
            m_space = m_space - remainingLength
            remainingLength = 0
        End If

        m_buffer(m_buffer.Count - 1) = temp
    Loop
End Sub

Public Function GetBytes() As Byte()
    Dim ret() As Byte
    ReDim ret(m_buffer.Count - 1)

    Dim i As Long

    For i = 0 To m_buffer.Count - 1
        ret(i) = m_buffer(i)
    Next

    GetBytes = ret
End Function
