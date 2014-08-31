/*
 * Structure containing configuration loaded from config file.
 */
typedef struct {
	char separator[256];
	char title[256];

	Key keys[640]; // 640 kb (key bindings) should be enough for anybody
	int nkeys;
} Configuration;
