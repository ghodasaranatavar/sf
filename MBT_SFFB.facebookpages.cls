global class facebookpages {
global facebookpages()
{
}
    global static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    global class Data_Z {
        global String access_token {get;set;} 
        global String id {get;set;} 
        global String name {get;set;} 
        global Picture picture {get;set;} 

        global Data_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'access_token') {
                            access_token = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'picture') {
                            picture = new Picture(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global Accounts accounts {get;set;} 
    global String id {get;set;} 

    global facebookpages(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'accounts') {
                        accounts = new Accounts(parser);
                    } else if (text == 'id') {
                        id = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    global class Picture {
        global Data data {get;set;} 

        global Picture(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'data') {
                            data = new Data(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Picture consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Paging {
        global Cursors cursors {get;set;} 

        global Paging(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'cursors') {
                            cursors = new Cursors(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Paging consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Cursors {
        global String before {get;set;} 
        global String after {get;set;} 

        global Cursors(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'before') {
                            before = parser.getText();
                        } else if (text == 'after') {
                            after = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Cursors consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Data {
        global Boolean is_silhouette {get;set;} 
        global String url {get;set;} 

        global Data(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'is_silhouette') {
                            is_silhouette = parser.getBooleanValue();
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    global class Accounts {
        global List<Data_Z> data {get;set;} 
        global Paging paging {get;set;} 

        global Accounts(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'data') {
                            data = new List<Data_Z>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                data.add(new Data_Z(parser));
                            }
                        } else if (text == 'paging') {
                            paging = new Paging(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Accounts consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    global static facebookpages parse(String json) {
        return new facebookpages(System.JSON.createParser(json));
    }
}