﻿перем Морфер;
Перем МассивПадежей;
#Область Получение_данных_для_печати
Функция ПолучитьДанныеПоОрганизации(ЗНАЧ Организация,ДатаДанных=Неопределено) Экспорт
	СтруктураВозврата=Новый Структура;
	СтруктураВозврата.Вставить("ОрганизацияПолное",	Организация.НаименованиеПолное);
	СтруктураВозврата.Вставить("ОрганизацияСокр",	Организация.НаименованиеСокращенное);
	СтруктураВозврата.Вставить("ИНН",				Организация.ИНН);
	СтруктураВозврата.Вставить("КПП",				Организация.КПП);
	СтруктураВозврата.Вставить("ОРГН",				Организация.ОГРН);
	
	Руководители=ПолучитьОтветственныхЛиц(Организация,?(ДатаДанных=Неопределено,ТекущаяДатаСеанса(),КонецДня(ДатаДанных)));
	
#Область Подписи_директора
	Директор=Руководители[Перечисления.ОтветственныеЛицаОрганизаций.Руководитель];
	Если Директор<>Неопределено Тогда
		ФИО=ПолучитьДанныеПоФизЛицу(Директор.ФизЛицо,ДатаДанных).ДанныеФИО;
		СтруктураВозврата.Вставить("Директор_ФИО_ИП",ФИО[0]);
		СтруктураВозврата.Вставить("Директор_ФИО_РП",ФИО[1]);
		СтруктураВозврата.Вставить("Директор_ФИО_ДП",ФИО[2]);
		СтруктураВозврата.Вставить("Директор_ФИО_ВП",ФИО[3]);
		СтруктураВозврата.Вставить("Директор_ФИО_ТП",ФИО[4]);
		СтруктураВозврата.Вставить("Директор_ФИО_ПП",ФИО[5]);
		
		ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[0]," ");
		СтруктураВозврата.Вставить("Директор_ФамИО_ИП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
		ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[1]," ");
		СтруктураВозврата.Вставить("Директор_ФамИО_РП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
		ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[2]," ");
		СтруктураВозврата.Вставить("Директор_ФамИО_ДП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
		ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[3]," ");
		СтруктураВозврата.Вставить("Директор_ФамИО_ВП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
		ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[4]," ");
		СтруктураВозврата.Вставить("Директор_ФамИО_ТП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
		ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[5]," ");
		СтруктураВозврата.Вставить("Директор_ФамИО_ПП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
		
		Должность=ПолучитьДанныеПоДолжности(Директор.Должность);
		СтруктураВозврата.Вставить("Директор_Должность_ИП",Должность[0]);
		СтруктураВозврата.Вставить("Директор_Должность_РП",Должность[1]);
		СтруктураВозврата.Вставить("Директор_Должность_ДП",Должность[2]);
		СтруктураВозврата.Вставить("Директор_Должность_ВП",Должность[3]);
		СтруктураВозврата.Вставить("Директор_Должность_ТП",Должность[4]);
		СтруктураВозврата.Вставить("Директор_Должность_ПП",Должность[5]);
	КонецЕсли;
#КонецОбласти

#Область Адреса
	Данные = Новый Структура("Объект, Тип, Вид",Организация, Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	Результат = РегистрыСведений.КонтактнаяИнформация.Получить(Данные);
	Если Результат <> Неопределено Тогда
		СтруктураВозврата.Вставить("ЮрАдресОрганизации",Результат.Представление);
	Иначе
		СтруктураВозврата.Вставить("ЮрАдресОрганизации","_____________________________________________________________________");
	КонецЕсли;
	
	Данные = Новый Структура("Объект, Тип, Вид",Организация, Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	Результат = РегистрыСведений.КонтактнаяИнформация.Получить(Данные);
	Если Результат <> Неопределено Тогда
		СтруктураВозврата.Вставить("ФактАдресОрганизации",Результат.Представление);
	Иначе
		СтруктураВозврата.Вставить("ФактАдресОрганизации","_____________________________________________________________________");
	КонецЕсли;
#КонецОбласти

#Область Банковские_реквизиты
	БанкСчет=Организация.ОсновнойБанковскийСчет;
	СтруктураВозврата.Вставить("РасчСчетОрганизации",	БанкСчет.Код);
	СтруктураВозврата.Вставить("КоррСчетОрганизации",	БанкСчет.Банк.КоррСчет);
	СтруктураВозврата.Вставить("БИКОрганизации",		БанкСчет.Банк.Код);
	СтруктураВозврата.Вставить("БанкОрганизации",		БанкСчет.Банк.Наименование);
#КонецОбласти

	Возврат СтруктураВозврата;
КонецФункции

Функция ПолучитьДанныеПоСотруднику(ЗНАЧ Сотрудник,ДатаДанных=Неопределено) Экспорт
	СтруктураВозврата=Новый Структура;
	
#Область Подписи_сотрудника
	ФИО=ПолучитьДанныеПоФизЛицу(Сотрудник.ФизЛицо,ДатаДанных).ДанныеФИО;
	СтруктураВозврата.Вставить("Сотрудник_ФИО_ИП",ФИО[0]);
	СтруктураВозврата.Вставить("Сотрудник_ФИО_РП",ФИО[1]);
	СтруктураВозврата.Вставить("Сотрудник_ФИО_ДП",ФИО[2]);
	СтруктураВозврата.Вставить("Сотрудник_ФИО_ВП",ФИО[3]);
	СтруктураВозврата.Вставить("Сотрудник_ФИО_ТП",ФИО[4]);
	СтруктураВозврата.Вставить("Сотрудник_ФИО_ПП",ФИО[5]);

	ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[0]," ");
	СтруктураВозврата.Вставить("Сотрудник_ФамИО_ИП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
	ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[1]," ");
	СтруктураВозврата.Вставить("Сотрудник_ФамИО_РП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
	ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[2]," ");
	СтруктураВозврата.Вставить("Сотрудник_ФамИО_ДП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
	ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[3]," ");
	СтруктураВозврата.Вставить("Сотрудник_ФамИО_ВП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
	ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[4]," ");
	СтруктураВозврата.Вставить("Сотрудник_ФамИО_ТП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
	ФИОТемп=ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ФИО[5]," ");
	СтруктураВозврата.Вставить("Сотрудник_ФамИО_ПП",ОбщегоНазначенияЗК.ФамилияИнициалыФизЛица(,ФИОТемп[0],ФИОТемп[1],ФИОТемп[2]));
	
	Рез=РегистрыСведений.РаботникиОрганизаций.ПолучитьПоследнее(?(ДатаДанных=Неопределено,ТекущаяДатаСеанса(),КонецДня(ДатаДанных)),Новый Структура("Сотрудник",Сотрудник));
	Должность=ПолучитьДанныеПоДолжности(Рез.Должность);
	СтруктураВозврата.Вставить("Сотрудник_Должность_ИП",Должность[0]);
	СтруктураВозврата.Вставить("Сотрудник_Должность_РП",Должность[1]);
	СтруктураВозврата.Вставить("Сотрудник_Должность_ДП",Должность[2]);
	СтруктураВозврата.Вставить("Сотрудник_Должность_ВП",Должность[3]);
	СтруктураВозврата.Вставить("Сотрудник_Должность_ТП",Должность[4]);
	СтруктураВозврата.Вставить("Сотрудник_Должность_ПП",Должность[5]);
#КонецОбласти
КонецФункции

Функция ПолучитьДанныеПоФизЛицу(ЗНАЧ ФизЛицо,ДатаДанных=Неопределено) Экспорт
	СтруктураВозврата=Новый Структура;
	
	СтруктураВозврата.Вставить("ДатаРождения",	Формат(ФизЛицо.ДатаРождения,"ДЛФ=DD"));
	СтруктураВозврата.Вставить("ГодРождения",	Формат(Год(ФизЛицо.ДатаРождения),"ЧЦ=4; ЧГ="));
	
#Область ФИО
	ДанныеФИО=ПолучитьСклоненияИзРегистраСвойств(ФизЛицо);
	Если ДанныеФИО=Неопределено Тогда
		Рез=РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(?(ДатаДанных=Неопределено,ТекущаяДатаСеанса(),КонецДня(ДатаДанных)),Новый Структура("ФизЛицо",ФизЛицо));
		ДанныеФИО=ПросклонятьМорфер(Рез.Фамилия+" "+Рез.Имя+" "+Рез.Отчество);
		//Сохраняем в регистр
		ВыборкаСвойств=ПланыВидовХарактеристик.СвойстваОбъектов.Выбрать(,Новый Структура("НазначениеСвойства",ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ФизическиеЛица));
		Пока ВыборкаСвойств.Следующий() Цикл
			Если МассивПадежей.Найти(ВыборкаСвойств.Наименование)<>Неопределено Тогда
				ЗаписьСклонения=РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
				ЗаписьСклонения.Объект		= ФизЛицо;
				ЗаписьСклонения.Свойство	= ВыборкаСвойств.Ссылка;
				ЗаписьСклонения.Значение	= ДанныеФИО[МассивПадежей.Найти(ВыборкаСвойств.Наименование)];
				ЗаписьСклонения.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	СтруктураВозврата.Вставить("ДанныеФИО",ДанныеФИО);
#КонецОбласти
	
#Область Паспорт
	Срез=РегистрыСведений.ПаспортныеДанныеФизЛиц.ПолучитьПоследнее(?(ДатаДанных=Неопределено,ТекущаяДатаСеанса(),КонецДня(ДатаДанных)),Новый Структура("ФизЛицо",ФизЛицо));
	Если ЗначениеЗаполнено(Срез.ДокументСерия) Тогда
		СтруктураВозврата.Вставить("Серия",Срез.ДокументСерия);
	Иначе
		СтруктураВозврата.Вставить("Серия","______");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Срез.ДокументНомер) Тогда
		СтруктураВозврата.Вставить("Номер",Срез.ДокументНомер);
	Иначе
		СтруктураВозврата.Вставить("Номер","___________");
	КонецЕсли;
	Если ЗначениеЗаполнено(Срез.ДокументКемВыдан) Тогда
		СтруктураВозврата.Вставить("Выдан",Срез.ДокументКемВыдан);
	Иначе
		СтруктураВозврата.Вставить("Выдан","________________________________________________________________");
	КонецЕсли;	
	Если ЗначениеЗаполнено(Срез.ДокументДатаВыдачи) Тогда
		СтруктураВозврата.Вставить("ДатаВыдачи",Формат(Срез.ДокументДатаВыдачи,"ДФ='dd MMMM yyyy ""г.""'"));
	Иначе
		СтруктураВозврата.Вставить("Номер"," ""___"" ________  _____ г.");
	КонецЕсли;
#КонецОбласти

#Область Адреса
	Данные = Новый Структура("Объект, Тип, Вид",ФизЛицо, Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.ЮрАдресФизЛица);
	Результат = РегистрыСведений.КонтактнаяИнформация.Получить(Данные);
	Если Результат <> Неопределено Тогда
		СтруктураВозврата.Вставить("АдресРегистрации",Результат.Представление);
	Иначе
		СтруктураВозврата.Вставить("АдресРегистрации","_____________________________________________________________________");
	КонецЕсли;
	
	Данные = Новый Структура("Объект, Тип, Вид",ФизЛицо, Перечисления.ТипыКонтактнойИнформации.Адрес, Справочники.ВидыКонтактнойИнформации.ФактАдресФизЛица);
	Результат = РегистрыСведений.КонтактнаяИнформация.Получить(Данные);
	Если Результат <> Неопределено Тогда
		СтруктураВозврата.Вставить("АдресПроживания",Результат.Представление);
	Иначе
		СтруктураВозврата.Вставить("АдресПроживания","_____________________________________________________________________");
	КонецЕсли;
#КонецОбласти

	Возврат СтруктураВозврата;
КонецФункции

Функция ПолучитьДанныеПоДолжности(ЗНАЧ Должность) Экспорт
	ДанныеДолжности=ПолучитьСклоненияИзРегистраСвойств(Должность);
	Если ДанныеДолжности=Неопределено Тогда
		ДанныеДолжности=ПросклонятьМорфер(Должность.Наименование);
		//Сохраняем в регистр
		ВыборкаСвойств=ПланыВидовХарактеристик.СвойстваОбъектов.Выбрать(,Новый Структура("НазначениеСвойства",ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДолжностиОрганизаций));
		Пока ВыборкаСвойств.Следующий() Цикл
			Если МассивПадежей.Найти(ВыборкаСвойств.Наименование)<>Неопределено Тогда
				ЗаписьСклонения=РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
				ЗаписьСклонения.Объект		= Должность;
				ЗаписьСклонения.Свойство	= ВыборкаСвойств.Ссылка;
				ЗаписьСклонения.Значение	= ДанныеДолжности[МассивПадежей.Найти(ВыборкаСвойств.Наименование)];
				ЗаписьСклонения.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат ДанныеДолжности;
КонецФункции
#КонецОбласти

#Область Вспомогательные_процедуры_и_функции
Функция ПросклонятьМорфер(ВхСтрока)
	Попытка
		результат = Морфер.GetXml(ВхСтрока);
		РезВозврат=Новый Массив;
		РезВозврат.Добавить(ВхСтрока);
		РезВозврат.Добавить(результат.Р);
		РезВозврат.Добавить(результат.Д);
		РезВозврат.Добавить(результат.В);
		РезВозврат.Добавить(результат.Т);
		РезВозврат.Добавить(результат.П);
		Возврат РезВозврат;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

Функция ПолучитьСклоненияИзРегистраСвойств(Объект)
	РезВозврат=Новый Массив;
	Если ТипЗнч(Объект)=Тип("СправочникСсылка.ФизическиеЛица") Тогда
		НазначениеСвойства=ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ФизическиеЛица;
	ИначеЕсли ТипЗнч(Объект)=Тип("СправочникСсылка.ДолжностиОрганизаций") Тогда
		НазначениеСвойства=ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДолжностиОрганизаций;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияСвойствОбъектов.Свойство.Наименование КАК Свойство,
		|	ЗначенияСвойствОбъектов.Значение
		|ИЗ
		|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|ГДЕ
		|	ЗначенияСвойствОбъектов.Объект = &Объект
		|	И ЗначенияСвойствОбъектов.Свойство.НазначениеСвойства = &НазначениеСвойства";
	
	Запрос.УстановитьПараметр("НазначениеСвойства", НазначениеСвойства);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если МассивПадежей.Найти(ВыборкаДетальныеЗаписи.Свойство)<>Неопределено Тогда
			РезВозврат.Вставить(МассивПадежей.Найти(ВыборкаДетальныеЗаписи.Свойство),ВыборкаДетальныеЗаписи.Значение);
		КонецЕсли;
	КонецЦикла;
	Если ЗначениеЗаполнено(РезВозврат) Тогда
		Возврат РезВозврат;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ПолучитьОтветственныхЛиц(Организация,ДатаСреза)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо,
		|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность,
		|	ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо
		|ИЗ
		|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&ДатаСреза, СтруктурнаяЕдиница = &Организация) КАК ОтветственныеЛицаОрганизацийСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СоотвВозврат=Новый Соответствие;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СоотвВозврат.Вставить(ВыборкаДетальныеЗаписи.ОтветственноеЛицо,Новый Структура("Должность,ФизЛицо",ВыборкаДетальныеЗаписи.Должность,ВыборкаДетальныеЗаписи.ФизическоеЛицо));
	КонецЦикла;
	Возврат СоотвВозврат;
КонецФункции
#КонецОбласти

ОпределениеМорфер=Новый WSОпределения("http://api.morpher.ru/WebService.asmx?WSDL");
Морфер=Новый WSПрокси(ОпределениеМорфер,"http://morpher.ru/","WebService","WebServiceSoap");

МассивПадежей=Новый Массив;
МассивПадежей.Добавить("1. Именительный");
МассивПадежей.Добавить("2. Родительный");
МассивПадежей.Добавить("3. Дательный");
МассивПадежей.Добавить("4. Винительный");
МассивПадежей.Добавить("5. Творительный");
МассивПадежей.Добавить("6. Предложный");
