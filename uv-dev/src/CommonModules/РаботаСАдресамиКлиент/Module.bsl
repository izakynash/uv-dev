///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПоказатьКлассификатор(ПараметрыОткрытия, ВладелецФормы, РежимОткрытияОкна = Неопределено) Экспорт
	
	ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, ВладелецФормы,,,,, РежимОткрытияОкна);
	
КонецПроцедуры

Процедура ОчиститьАдрес(НаселенныйПунктДетально) Экспорт
	
	Для каждого ЭлементАдреса Из НаселенныйПунктДетально Цикл
		
		Если СтрСравнить(ЭлементАдреса.Ключ, "type") = 0 Тогда
				Продолжить;
		ИначеЕсли СтрСравнить(ЭлементАдреса.Ключ, "buildings") = 0 
			ИЛИ СтрСравнить(ЭлементАдреса.Ключ, "apartments") = 0
			ИЛИ СтрСравнить(ЭлементАдреса.Ключ, "munLevels") = 0
			ИЛИ СтрСравнить(ЭлементАдреса.Ключ, "admLevels") = 0 Тогда
				НаселенныйПунктДетально[ЭлементАдреса.Ключ] = Новый Массив;
		Иначе
			НаселенныйПунктДетально[ЭлементАдреса.Ключ] = "";
		КонецЕсли;
		
	КонецЦикла;
	
	НаселенныйПунктДетально.addressType = РаботаСАдресамиКлиентСервер.МуниципальныйАдрес();

КонецПроцедуры

Функция ЭтоАдминистративноТерриториальныйАдрес(ТипАдреса) Экспорт
	Возврат СтрСравнить(ТипАдреса, РаботаСАдресамиКлиентСервер.АдминистративноТерриториальныйАдрес()) = 0;
КонецФункции

// Телефон 

// Показать подсказку корректности кода города при вводе телефона.
// 
// Параметры:
//  КодСтраны - Строка
//  КодГорода - Строка
// 
Процедура ПоказатьПодсказкуКорректностиКодовСтраныИГорода(КодСтраны, КодГорода) Экспорт
	Если (КодСтраны = "+7" ИЛИ КодСтраны = "8") И СтрНачинаетсяС(КодГорода, "9") И СтрДлина(КодГорода) <> 3 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Коды мобильных телефонов начинающиеся на цифру 9 имеют фиксированную длину в 3 цифры, например - 916.'"),, "КодГорода");
	КонецЕсли;
КонецПроцедуры

// Проверить корректность кода города и номера телефона кодов страны.
// 
// Параметры:
//  ПоляТелефона - см. УправлениеКонтактнойИнформациейКлиентСервер.СтруктураПолейТелефона
//  СписокОшибок - СписокЗначений
// 
Процедура ПроверитьКорректностьКодовСтраныИГорода(ПоляТелефона, СписокОшибок) Экспорт
	
	РаботаСАдресамиКлиентСервер.ПроверитьКорректностьКодовСтраныИГорода(ПоляТелефона, СписокОшибок);
	
КонецПроцедуры

#КонецОбласти