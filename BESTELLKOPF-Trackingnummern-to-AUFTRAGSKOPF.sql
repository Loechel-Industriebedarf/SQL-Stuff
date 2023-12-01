USE LOE01
INSERT INTO [dbo].AdditionalFieldValue (DefRowID, TableRowID, ValueString)
SELECT 'BEF38EDC-2DBF-11E8-949A-000C29018628', [dbo].AUFTRAGSKOPF.[FSROWID], ValueString
FROM [dbo].[BESTELLKOPF] 
LEFT JOIN [dbo].AdditionalFieldValue ON dbo.[BESTELLKOPF].FSROWID = dbo.AdditionalFieldValue.TableRowID
LEFT JOIN [dbo].[AUFTRAGSKOPF] ON dbo.[AUFTRAGSKOPF].BELEGNR = [dbo].[BESTELLKOPF].AUFTRAGSNR
WHERE [dbo].AdditionalFieldValue.DefRowID='BCE33303-72C2-11E8-9EBF-000C29018628' AND [dbo].AdditionalFieldValue.ValueString Is Not Null