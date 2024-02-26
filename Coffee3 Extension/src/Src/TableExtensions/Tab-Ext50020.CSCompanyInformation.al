// tableextension 50020 "CS Company Information" extends "Company Information"
// {
//     procedure fPadLtoAlignBitmapCentre(PdecPointsW: Decimal; PdecPointsH: Decimal): Integer
//     var
//         InstrCompanyPicture: InStream;
//         Bitmap: dotnet bitmap;
//         LdecWidth: Decimal;
//         LdecHeight: Decimal;
//         LdecRatio: Decimal;
//         LdecRatioH: Decimal;
//         LdecRatioW: Decimal;
//     begin
//         // ************************************************************************************************************
//         //                                    1 Centimeter(cm) = 28.3464567 Points(pt)
//         //                                    1 Point(pt)      = 0.03527777776895834 Centimeter(cm)
//         // ************************************************************************************************************
//         CalcFields(Picture);
//         Picture.CreateInStream(InstrCompanyPicture);

//         Bitmap := Bitmap.Bitmap(InstrCompanyPicture);
//         LdecWidth := Bitmap.Width * 72 / 96;
//         LdecHeight := Bitmap.Height * 72 / 96;

//         LdecRatioH := PdecPointsH / LdecHeight;
//         LdecRatioW := PdecPointsW / LdecWidth;

//         if LdecRatioH > LdecWidth then
//             LdecRatio := LdecRatioW
//         else
//             LdecRatio := LdecRatioH;

//         exit(Round((PdecPointsW - (LdecWidth * LdecRatio)) / 2, 1, '<'));
//     end;
// }
