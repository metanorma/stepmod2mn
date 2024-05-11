package org.metanorma;

public enum DocumentStatus {
    OK {
        public String toString() {
            return "";
        }
    },
    WITHDRAWN {
        public String toString() {
            return "." + name().toLowerCase();
        }
    },
    MISSING {
        public String toString() {
            return "." + name().toLowerCase();
        }
    },
    EXCLUDED {
        public String toString() {
            return "." + name().toLowerCase();
        }
    },
    SKIPPED {
        public String toString() {
            return "." + name().toLowerCase();
        }
    },
    WRONGPART {
        public String toString() {
            return "." + name().toLowerCase();
        }
    }
}
