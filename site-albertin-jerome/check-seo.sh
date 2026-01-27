#!/bin/bash

# Script de validation SEO
# Vérifie que tous les éléments SEO sont en place

echo "🔍 Vérification SEO du site Dr Jérôme ALBERTIN"
echo "================================================"
echo ""

# Compteurs
errors=0
warnings=0
success=0

# Fonction pour afficher les résultats
check_result() {
    if [ $1 -eq 0 ]; then
        echo "✅ $2"
        ((success++))
    else
        if [ "$3" == "warning" ]; then
            echo "⚠️  $2"
            ((warnings++))
        else
            echo "❌ $2"
            ((errors++))
        fi
    fi
}

# 1. Vérifier les fichiers essentiels
echo "📁 Fichiers SEO essentiels"
echo "--------------------------"

[ -f "sitemap.xml" ]
check_result $? "sitemap.xml existe"

[ -f "robots.txt" ]
check_result $? "robots.txt existe"

[ -f "404.html" ]
check_result $? "404.html existe"

[ -f ".htaccess" ]
check_result $? ".htaccess existe"

echo ""

# 2. Vérifier les meta tags dans les pages principales
echo "🏷️  Meta tags (pages principales)"
echo "--------------------------------"

for page in index.html chirurgien.html pathologies.html interventions.html contact.html expertise-endovasculaire.html; do
    if [ -f "$page" ]; then
        grep -q 'meta name="description"' "$page"
        check_result $? "Meta description présente dans $page"
        
        grep -q 'meta property="og:' "$page"
        check_result $? "Open Graph tags présents dans $page"
        
        grep -q 'link rel="canonical"' "$page"
        check_result $? "URL canonique présente dans $page"
    fi
done

echo ""

# 3. Vérifier les pages de pathologies
echo "🩺 Pages pathologies"
echo "-------------------"

for page in pathologies/varices.html pathologies/anevrisme.html pathologies/arterite.html pathologies/stenose-carotidienne.html pathologies/arterite-diabete.html pathologies/prevention.html; do
    if [ -f "$page" ]; then
        grep -q 'meta name="description"' "$page"
        check_result $? "Meta description dans $page"
    fi
done

echo ""

# 4. Vérifier le Schema.org
echo "📊 Données structurées"
echo "---------------------"

grep -q 'application/ld+json' index.html
check_result $? "Schema.org JSON-LD présent sur index.html"

grep -q '"@type": "Physician"' index.html
check_result $? "Type 'Physician' défini dans Schema.org"

echo ""

# 5. Vérifier les images
echo "🖼️  Optimisation images"
echo "----------------------"

missing_alt=0
for html_file in *.html pathologies/*.html; do
    if [ -f "$html_file" ]; then
        # Compter les images sans alt
        count=$(grep -o '<img[^>]*>' "$html_file" | grep -cv 'alt="')
        missing_alt=$((missing_alt + count))
    fi
done

[ $missing_alt -eq 0 ]
check_result $? "Toutes les images ont un attribut alt" "warning"

echo ""

# 6. Vérifier le sitemap.xml
echo "🗺️  Sitemap"
echo "----------"

pages_count=$(grep -c '<url>' sitemap.xml)
echo "   $pages_count pages dans le sitemap.xml"
[ $pages_count -ge 12 ]
check_result $? "Sitemap contient toutes les pages principales"

echo ""

# 7. Vérifier robots.txt
echo "🤖 Robots.txt"
echo "-------------"

grep -q 'Sitemap:' robots.txt
check_result $? "Référence au sitemap dans robots.txt"

grep -q 'Allow: /' robots.txt
check_result $? "Exploration autorisée dans robots.txt"

echo ""

# Résumé
echo "📈 RÉSUMÉ"
echo "========="
echo "✅ Succès : $success"
echo "⚠️  Avertissements : $warnings"
echo "❌ Erreurs : $errors"
echo ""

if [ $errors -eq 0 ]; then
    echo "🎉 Excellent ! Toutes les optimisations SEO sont en place."
    exit 0
elif [ $errors -le 3 ]; then
    echo "👍 Bon travail ! Quelques ajustements mineurs à faire."
    exit 0
else
    echo "⚠️  Des corrections sont nécessaires."
    exit 1
fi
