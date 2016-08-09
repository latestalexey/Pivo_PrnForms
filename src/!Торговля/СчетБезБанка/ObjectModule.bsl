﻿// Внешняя функция печати
// КТ-2000: (095)789-3070
// Параметры
//  ИмяМакета  – Строка – имя формы печати
//
// Возвращаемое значение:
//   Булево   –Печать прошла успешно - Истина, иначе - Ложь
//
Функция Печать(ИмяМакета = "", ПараметрыПечати = Неопределено)	Экспорт

	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(СсылкаНаОбъект.Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат Ложь;
	КонецЕсли;
	
	ТабДокумент = ПечатьДокумента(СсылкаНаОбъект);
	
	//Определим параметры печати
	Если ПараметрыПечати <> Неопределено Тогда
		КоличествоЭкземпляров = 1;
		Если НЕ(ПараметрыПечати.Свойство("КоличествоЭкземпляров",КоличествоЭкземпляров)) Тогда
			КоличествоЭкземпляров = 1;			
		КонецЕсли;
		НаПринтер = Ложь;
		Если НЕ(ПараметрыПечати.Свойство("НаПринтер",НаПринтер)) Тогда
			НаПринтер = Ложь;			
		КонецЕсли;
	КонецЕсли;
	Если КоличествоЭкземпляров = Неопределено Тогда
		КоличествоЭкземпляров = 1;
	КонецЕсли;
	Если НаПринтер = Неопределено Тогда
		НаПринтер = Ложь;
	КонецЕсли;
//---КТ-2000-(095)789-3070---Олег-27.06.05
	//НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ВыбОбъект));
	Возврат ТабДокумент;
//---КТ-2000-(095)789-3070---Олег-27.06.05

КонецФункции // Печать()

Функция ПечатьДокумента(СсылкаНаДокумент)
КонецФункции